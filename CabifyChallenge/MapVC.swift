//
//  MapVC.swift
//  CabifyChallenge
//
//  Created by Alberto on 7/10/16.
//  Copyright © 2016 aortegas. All rights reserved.
//

import UIKit
import MapKit
import RxSwift

enum SelectedPoints {
    case Any
    case StartPoint
    case Both
}

class MapVC: UIViewController {

    // MARK: - Properties
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var startPointView: UIView!
    @IBOutlet weak var labelStartPoint: UILabel!
    @IBOutlet weak var cancelStartPoint: UIButton!
    @IBOutlet weak var endPointView: UIView!
    @IBOutlet weak var labelEndPoint: UILabel!
    @IBOutlet weak var cancelEndPoint: UIButton!
    @IBOutlet weak var getVehicles: UIButton!

    private var locationManager: CLLocationManager
    private var statusLocation: CLAuthorizationStatus
    private var numberUpdatesPosition: UInt = 0
    private var selectedPoints = SelectedPoints.Any
    private var startPoint: MKAnnotation?
    private var endPoint: MKAnnotation?
    private var requestDataInProgress: Bool = false
    private var vehicles: [Vehicle]?
    
    lazy var alertView: AlertView = {
        let alertView = AlertView()
        return alertView
    }()

    
    // MARK: - Init
    init() {
        
        locationManager = CLLocationManager()
        statusLocation = CLAuthorizationStatus.NotDetermined
        super.init(nibName: "MapView", bundle: NSBundle(forClass: self.dynamicType))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Configure MapView.
        mapView.delegate = self
        
        // Configure Location Manager.
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        numberUpdatesPosition = 0
        
        // Add Gesture Recognizer
        let uilgr = UILongPressGestureRecognizer(target: self, action: #selector(MapVC.addAnnotation(_:)))
        uilgr.minimumPressDuration = 1.0
        mapView.addGestureRecognizer(uilgr)
        
        // Set up Views.
        setupViews()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBarHidden = true
        if selectedPoints == .Any {
            setUpStartPoint()
        }
    }
    

    // MARK: - Actions
    @IBAction func cancelStartPoint(sender: AnyObject) {

        mapView.removeAnnotation(startPoint!)
        if let endPoint = endPoint {
            mapView.removeAnnotation(endPoint)
        }
        setUpStartPoint()
        selectedPoints = SelectedPoints.Any
        vehicles = nil
    }
    
    @IBAction func cancelEndPoint(sender: AnyObject) {
        
        mapView.removeAnnotation(endPoint!)
        setUpEndPoint()
        selectedPoints = SelectedPoints.StartPoint
        vehicles = nil
    }
    
    @IBAction func getVehicles(sender: AnyObject) {
        
        if  vehicles != nil {
            showDataJourney()
        }
        else {
            postDataEstimates()
        }
    }
    
    
    // MARK: - Functions
    // New annotation (start & end point)
    func addAnnotation(gestureRecognizer:UIGestureRecognizer){
        
        if gestureRecognizer.state == UIGestureRecognizerState.Began {
            
            if (selectedPoints != .Both) {

                // Get touchPoint on the MapView.
                let touchPoint = gestureRecognizer.locationInView(mapView)
                let newCoordinates = mapView.convertPoint(touchPoint, toCoordinateFromView: mapView)
            
                // Create a annotation with coordinate.
                let annotation = MKPointAnnotation()
                annotation.coordinate = newCoordinates
            
                alertView.displayView(view, withTitle: pleaseWait)
            
                // Get Address of coordinate
                CLGeocoder().reverseGeocodeLocation(CLLocation(latitude: newCoordinates.latitude,
                                                              longitude: newCoordinates.longitude), completionHandler: {(placemarks, error) -> Void in
               
                    self.alertView.hideView()
                                                            
                    if error != nil {
                        showAlert(errorTitle, message: reverseGeocoderFailed, controller: self)
                        return
                    }
                
                    if placemarks!.count > 0 {
                        let pm = placemarks![0]
                        annotation.title = self.formatAddressFromPlacemark(pm)
                        self.mapView.addAnnotation(annotation)
                        self.setPoint(annotation)
                    }
                    else {
                        showAlert(errorTitle, message: reverseGeocoderErrorData, controller: self)
                        return
                                                                }
                })
            }
        }
    }
    
    // Get Formatted Address from a placemark.
    private func formatAddressFromPlacemark(placemark: CLPlacemark) -> String {
        return (placemark.addressDictionary!["FormattedAddressLines"] as! [String]).joinWithSeparator(", ")
    }
    
    // Zoom on map.
    private func zoomToMyPosition() {
        
        if statusLocation == CLAuthorizationStatus.AuthorizedAlways || statusLocation == CLAuthorizationStatus.AuthorizedWhenInUse {
            
            var userRegion: MKCoordinateRegion = MKCoordinateRegion()
            userRegion.center.latitude = (locationManager.location?.coordinate.latitude)!
            userRegion.center.longitude = (locationManager.location?.coordinate.longitude)!
            userRegion.span.latitudeDelta = spanInMap
            userRegion.span.longitudeDelta = spanInMap
            mapView.setRegion(userRegion, animated: true)
        }
    }
    
    // Set a info from points.
    private func setPoint(annotation: MKAnnotation) {
        
        switch selectedPoints {
        case .Any:
            labelStartPoint.text = annotation.title!
            cancelStartPoint.enabled = true
            cancelStartPoint.hidden = false
            startPoint = annotation
            selectedPoints = SelectedPoints.StartPoint
            setUpEndPoint()
            break
        
        case .StartPoint:
            labelEndPoint.text = annotation.title!
            cancelEndPoint.enabled = true
            cancelEndPoint.hidden = false
            endPoint = annotation
            selectedPoints = SelectedPoints.Both
            setUpVehiclesAndCost()
            break
            
        default: break
        }
    }
    
    // Setup views.
    private func setupViews() {
     
        startPointView.layer.cornerRadius = 6.0
        endPointView.layer.cornerRadius = 6.0
        getVehicles.layer.cornerRadius = 6.0
        getVehicles.setTitle(getVehiclesText, forState: UIControlState.Normal)
        getVehicles.enabled = false
        getVehicles.hidden = true
    }
    
    // Setup start point.
    private func setUpStartPoint() {
        
        labelStartPoint.text = setStartPoint
        cancelStartPoint.enabled = false
        cancelStartPoint.hidden = true
        labelEndPoint.text = ""
        cancelEndPoint.enabled = false
        cancelEndPoint.hidden = true
        endPointView.hidden = true
        startPoint = nil
        endPoint = nil
        downVehiclesAndCost()
    }

    // Setup end point.
    private func setUpEndPoint() {
        
        labelEndPoint.text = setEndPoint
        cancelEndPoint.enabled = false
        cancelEndPoint.hidden = true
        endPointView.hidden = false
        endPoint = nil
        downVehiclesAndCost()
    }
    
    // Setup get vehicles and costs.
    private func setUpVehiclesAndCost() {

        self.getVehicles.hidden = false
        self.getVehicles.alpha = 1.0
        UIView.animateWithDuration(1.0, animations: {
            self.getVehicles.frame = CGRectMake(self.getVehicles.frame.origin.x, self.getVehicles.frame.origin.y - 60,
                                                self.getVehicles.frame.size.width, self.getVehicles.frame.size.height)
            }, completion: { finished in
                self.getVehicles.enabled = true
        })
    }
    
    private func downVehiclesAndCost() {

        self.getVehicles.enabled = false
        
        UIView.animateWithDuration(1.0, animations: {
                self.getVehicles.alpha = 0.0
            }, completion: { finished in
                self.getVehicles.hidden = true
        })        
    }
    
    private func postDataEstimates() {
        
        if !isConnectedToNetwork() {
            showAlert(errorTitle, message: noConnectionMessage, controller: self)
            return
        }
        
        if requestDataInProgress {
            showAlert(errorTitle, message: apiConnectionNoPossible, controller: self)
            return
        }
        
        requestDataInProgress = true
        alertView.displayView(view, withTitle: pleaseWait)
        
        let session = Session.cabifySession()
        let _ = session.postEstimate((startPoint?.coordinate)!, endPoint: (endPoint?.coordinate)!)
            
            .observeOn(MainScheduler.instance)
            .subscribe { [weak self] event in
                
                self!.alertView.hideView()
                self?.requestDataInProgress = false
                
                switch event {
                case let .Next(vehicles):
                    self!.vehicles = vehicles
                    self!.showDataJourney()
                    
                case .Error (let error):
                    showAlert(errorTitle, message: String(error), controller: self!)
                    
                default:
                    break
                }
        }
    }
    
    private func showDataJourney() {
        
        let vehiclesListVC = VehiclesListVC(vehicles: vehicles!)
        self.navigationController?.pushViewController(vehiclesListVC, animated: true)
    }
}


// MARK: - Extension - CLLocationManager
extension MapVC: CLLocationManagerDelegate {
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        statusLocation = status
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if (numberUpdatesPosition < maxUpdatesPosition) {
            numberUpdatesPosition += 1
        } else {
            locationManager.stopUpdatingLocation()
            zoomToMyPosition()
        }
    }
}


// MARK: - Extension - MKMapViewDelegate
extension MapVC: MKMapViewDelegate {
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        let annotationIdentifier = "AnnotationIdentifier"
        var annotationView: MKAnnotationView?
        if let dequeuedAnnotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(annotationIdentifier) {
            annotationView = dequeuedAnnotationView
            annotationView?.annotation = annotation
        }
        else {
            let av = MKAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
            av.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure)
            annotationView = av
        }
        
        if let annotationView = annotationView {
            annotationView.canShowCallout = true
            if let startPoint = startPoint {
                if annotation.coordinate.latitude == startPoint.coordinate.latitude &&
                   annotation.coordinate.longitude == startPoint.coordinate.longitude {
                    annotationView.image = UIImage(named: "StartPoint")
                }
            }
            
            if let endPoint = endPoint {
                if annotation.coordinate.latitude == endPoint.coordinate.latitude &&
                    annotation.coordinate.longitude == endPoint.coordinate.longitude {
                    annotationView.image = UIImage(named: "EndPoint")
                }
            }            
        }
        
        return annotationView
    }
}
