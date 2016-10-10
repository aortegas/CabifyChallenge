//
//  Utils.swift
//  CabifyChallenge
//
//  Created by Alberto on 7/10/16.
//  Copyright © 2016 aortegas. All rights reserved.
//

import UIKit
import SystemConfiguration
import RxSwift

func showAlert(title: String, message: String, controller: UIViewController) {
    
    let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
    alertController.addAction(UIAlertAction(title: ok, style: .Default, handler: nil))
    controller.presentViewController(alertController, animated: true, completion: nil)
}

func isConnectedToNetwork() -> Bool {
    
    var zeroAddress = sockaddr_in()
    zeroAddress.sin_len = UInt8(sizeofValue(zeroAddress))
    zeroAddress.sin_family = sa_family_t(AF_INET)
    let defaultRouteReachability = withUnsafePointer(&zeroAddress) {
        SCNetworkReachabilityCreateWithAddress(nil, UnsafePointer($0))
    }
    var flags = SCNetworkReachabilityFlags()
    if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
        return false
    }
    let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
    let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
    return (isReachable && !needsConnection)
}

func loadImage(imageUrl: NSURL, imageView: UIImageView, withAnimation: Bool) {
    
    let session = Session.cabifySessionImages()
    let _ = session.getImageData(imageUrl)
        
        .observeOn(MainScheduler.instance)
        .subscribe { event in
            
            switch event {
            case let .Next(data):
                let image = UIImage(data: data)
                imageView.image = image
                if withAnimation {
                    imageView.fadeOut(duration: 0.0)
                    imageView.fadeIn()
                }
                
            case .Error (let error):
                print(error)
                return
                
            default:
                break
            }
    }
}
