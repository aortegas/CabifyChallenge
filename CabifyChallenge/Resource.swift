//
//  Resource.swift
//  CabifyChallenge
//
//  Created by Alberto on 8/10/16.
//  Copyright © 2016 aortegas. All rights reserved.
//

import Foundation

enum Method: String
{
    case POST = "POST"
    case GET = "GET"
}

protocol Resource {
    var method: Method { get }
    var path: String { get }
    var parameters: [String: AnyObject] { get }
}

// MARK: - Extension
extension Resource {
    
    var parameters: [String: String] {
        return [:]
    }
    
    func requestWithBaseURL(baseURL: NSURL) -> NSURLRequest {
        
        let URL = baseURL.URLByAppendingPathComponent(path)
        let request: NSMutableURLRequest = NSMutableURLRequest(URL: URL)
        request.HTTPMethod = method.rawValue
        
        if method == Method.POST {

            do {
                request.addValue(contentTypeHeaderValue, forHTTPHeaderField: contentTypeHeaderField)
                request.addValue("\(authorizationBearer) \(tokenHeaderValue)", forHTTPHeaderField: authorizationHeaderField)
                request.addValue(english, forHTTPHeaderField: acceptLanguajeHeaderField)
                try request.HTTPBody = NSJSONSerialization.dataWithJSONObject(parameters, options: .PrettyPrinted)
                //let strData = NSString(data: request.HTTPBody!, encoding: NSUTF8StringEncoding)
                //print("Body: \(strData)")
            
            } catch {
                fatalError("Unable to create HTTP body data")
            }
        }
        
        return request
    }
}
