//
//  VehiclesListVC.swift
//  CabifyChallenge
//
//  Created by Alberto on 9/10/16.
//  Copyright © 2016 aortegas. All rights reserved.
//

import UIKit

class VehiclesListVC: UIViewController {
    
    // MARK: - Constants
    let nibId = "VehicleCollectionView"
    let collectionId = "VehicleCollection"
    let withCollection: CGFloat = 130

    
    // MARK: - Properties
    @IBOutlet weak var vehiclesCollectionView: UICollectionView!
    
    private var vehicles: [Vehicle]
    
    
    //MARK: Init.
    init(vehicles: [Vehicle]) {
        
        self.vehicles = vehicles
        super.init(nibName: "VehiclesListView", bundle: NSBundle(forClass: self.dynamicType))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Register Nib Cells.
        registerCustomCell()
        
        // Configure Views.
        setupViews()

        // Configure collection views.
        vehiclesCollectionView.delegate = self
        vehiclesCollectionView.dataSource = self
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBarHidden = false
    }
    
    
    //MARK: Private Functions.
    private func registerCustomCell() {
        vehiclesCollectionView.registerNib(UINib(nibName: nibId, bundle: nil), forCellWithReuseIdentifier: collectionId)
    }

    private func setupViews() {
        
        // Customize Navigation Bar.
        UINavigationBar.appearance().titleTextAttributes = [NSFontAttributeName: UIFont(name: "Avenir-Medium", size: 15)!]
        self.title = vehiclesCostText
        var backBtn = UIImage(named: "Back");
        backBtn = backBtn?.imageWithRenderingMode(.AlwaysOriginal)
        self.navigationController?.navigationBar.topItem?.title = ""
        self.navigationController!.navigationBar.backIndicatorImage = backBtn
        self.navigationController!.navigationBar.backIndicatorTransitionMaskImage = backBtn
    }
}


// MARK: - Extensions - Collection view delegates and datasource
extension VehiclesListVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (vehicles.count)
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let collection = collectionView.dequeueReusableCellWithReuseIdentifier(collectionId, forIndexPath: indexPath) as! VehicleCollectionView
        Appearance.setupCollection(collection)
        collection.vehicle = vehicles[indexPath.row % vehicles.count]
        return collection
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake((UIScreen.mainScreen().bounds.width)/2.4, withCollection)
    }
}





