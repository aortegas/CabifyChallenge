//
//  CabifySession.swift
//  CabifyChallenge
//
//  Created by Alberto on 8/10/16.
//  Copyright © 2016 aortegas. All rights reserved.
//

import Foundation
import MapKit
import RxSwift

// MARK: - Extension Session
extension Session {
    
    // MARK: - Methods
    static func cabifySession() -> Session {
        return Session(baseURL: cabifyBaseURL)
    }
    
    static func cabifySessionImages() -> Session {
        return Session(baseURL: cabifyBaseURLImages)
    }
    
    func response(resource: Resource) -> Observable<Response> {
        
        return data(resource).map { data in
            
            guard let response: Response = decode(data) else {
                throw SessionError.CouldNotDecodeJSON
            }
            return response
        }
    }    
}

// MARK: - Extension cabify Requests
extension Session {
    
    // POST New Estimate.
    func postEstimate(startPoint: CLLocationCoordinate2D, endPoint: CLLocationCoordinate2D) -> Observable<[Vehicle]> {
        
        return response(APIRequest.postEstimate(startPoint: startPoint, endPoint: endPoint)).map { response in
            return try self.returnVehicles(response)
        }
    }

    // GET Image Data.
    func getImageData(urlImage: NSURL) -> Observable<NSData> {
        
        return data(APIRequest.getImageData(urlImage: urlImage)).map { data in
            return data
        }
    }


    // MARK: - Private responses.
    private func returnVehicles(response: Response) throws -> [Vehicle] {
        
        guard response.message == nil else {
            throw SessionError.Other(error: response.message!)
        }
        
        guard let results = response.resultsResponse,
                    vehicles: [Vehicle] = decode(results) else {
            throw SessionError.CouldNotDecodeJSON
        }
        
        return vehicles
    }
}











