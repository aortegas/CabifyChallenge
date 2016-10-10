//
//  VehicleCollectionView.swift
//  CabifyChallenge
//
//  Created by Alberto on 9/10/16.
//  Copyright © 2016 aortegas. All rights reserved.
//

import UIKit

class VehicleCollectionView: UICollectionViewCell {
    
    // MARK: - Properties
    @IBOutlet weak var imageVehicle: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    var vehicle: Vehicle? {
        didSet {
            if let vehicle = vehicle {
                
                nameLabel.text = vehicle.name
                priceLabel.text = vehicle.price
                loadImage(vehicle.icon, imageView: imageVehicle, withAnimation: true)
            }
        }
    }
}