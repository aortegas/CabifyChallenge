//
//  Session.swift
//  CabifyChallenge
//
//  Created by Alberto on 8/10/16.
//  Copyright © 2016 aortegas. All rights reserved.
//

import Foundation
import RxSwift

// MARK: Enums
enum SessionError: ErrorType {
    case CouldNotDecodeJSON
    case BadHTTPStatus(status: Int)
    case APIErrorNoData
    case Other(error: String)
}


// MARK: Extensions
extension SessionError: CustomDebugStringConvertible {
    var debugDescription: String {
        switch self {
        case .CouldNotDecodeJSON:
            return "Could not decode JSON"
        case let .BadHTTPStatus(status):
            return "Bad Status: \(status)"
        case .APIErrorNoData:
            return "No data found"
        case let .Other(error):
            return "\(error)"
        }
    }
}


// MARK: Class
final class Session {
    
    // MARK: - Private properties
    private let session: NSURLSession = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
    private let baseURL: NSURL
    
    
    // MARK: - Init
    init(baseURL: NSURL) {
        self.baseURL = baseURL
    }
    
    
    // MARK: - Methods
    func data(resource: Resource) -> Observable<NSData> {
        
        let request = resource.requestWithBaseURL(baseURL)
        
        return Observable.create { observer in
            
            let task = self.session.dataTaskWithRequest(request) { data, response, error in
                
                if let error = error {
                    
                    observer.onError(SessionError.Other(error: error.localizedDescription))
                    
                } else {
                    
                    guard let HTTPResponse = response as? NSHTTPURLResponse else {
                        fatalError("Couldn't get HTTP response")
                    }
                    
                    if (200 ..< 300 ~= HTTPResponse.statusCode || HTTPResponse.statusCode == 404) {
                        observer.onNext(data ?? NSData())
                        observer.onCompleted()
                        
                    } else {
                        observer.onError(SessionError.BadHTTPStatus(status: HTTPResponse.statusCode))
                    }
                }
            }
            
            task.resume()
            
            return AnonymousDisposable {
                task.cancel()
            }
        }
    }
}

