//
//  Vehicle.swift
//  CabifyChallenge
//
//  Created by Alberto on 8/10/16.
//  Copyright © 2016 aortegas. All rights reserved.
//

import Foundation

enum JSONKeysVehicle: String {
    case vehicleType = "vehicle_type"
    case id = "_id"
    case name = "name"
    case icons = "icons"
    case regular = "regular"
    case price = "price_formatted"
}

struct Vehicle {
    let id: String
    let name: String
    let icon: NSURL
    let price: String
}


extension Vehicle: JSONDecodable {
    
    // MARK: - Init
    init?(dictionaries: [JSONDictionary]) {
        
        let dictionary = dictionaries[0]
        
        guard let vehicleType = dictionary[JSONKeysVehicle.vehicleType.rawValue] as? JSONDictionary else {
            return nil
        }
        
        guard let id = vehicleType[JSONKeysVehicle.id.rawValue] as? String,
                    name = vehicleType[JSONKeysVehicle.name.rawValue] as? String,
                    icons = vehicleType[JSONKeysVehicle.icons.rawValue] as? JSONDictionary else {
            return nil
        }
        
        guard let regular = icons[JSONKeysVehicle.regular.rawValue] as? String,
                    icon = NSURL(string: regular) else {
            return nil
        }
        
        guard let price = dictionary[JSONKeysVehicle.price.rawValue] as? String else {
            return nil
        }
        
        self.id = id
        self.name = name
        self.price = price
        self.icon = icon
    }
}


