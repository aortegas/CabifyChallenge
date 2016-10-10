//
//  APIRequest.swift
//  CabifyChallenge
//
//  Created by Alberto on 8/10/16.
//  Copyright © 2016 aortegas. All rights reserved.
//

import Foundation
import MapKit

enum APIRequest {
    case postEstimate(startPoint: CLLocationCoordinate2D, endPoint: CLLocationCoordinate2D)
    case getImageData(urlImage: NSURL)
}

extension APIRequest: Resource {
    
    var method: Method {
        switch self {
        case .getImageData:
            return Method.GET
        case .postEstimate:
            return Method.POST
        }
    }
    
    var path: String {
        switch self {
        case .postEstimate:
            return "/estimate"
            
        case let .getImageData(urlImage):
            let pathComponents = urlImage.pathComponents
            var urlPathComponents = String()
            for i in 0...pathComponents!.count - 1 {
                if i > 1 {
                    urlPathComponents += "/\(pathComponents![i])"
                }
            }
            return urlPathComponents
        }
    }
    
    var parameters: [String: AnyObject] {
        switch self {
        case let .postEstimate(
            startPoint: startPoint,
            endPoint: endPoint):
            
            let startPoint: [String : [Double]] = ["loc": [startPoint.latitude, startPoint.longitude]]
            let endPoint: [String : [Double]] = ["loc": [endPoint.latitude, endPoint.longitude]]
            let stops = [startPoint, endPoint]
            return ["stops": stops, "start_at": ""]
        
        case .getImageData:
            return [:]
        }
    }
}







