//
//  Response.swift
//  CabifyChallenge
//
//  Created by Alberto on 8/10/16.
//  Copyright © 2016 aortegas. All rights reserved.
//

import Foundation

enum JSONKeysResponse: String {
    case message = "message"
}

struct Response {
    
    let message: String?
    private let payload: AnyObject?
    
    var resultsResponse: [JSONDictionary]? {
        
        guard let dictionaries = payload as? [JSONDictionary] else {
            return nil
        }
        return dictionaries
    }
}

extension Response: JSONDecodable {
    
    init?(dictionaries: [JSONDictionary]) {
        
        if dictionaries.count == 0 {
            return nil
        }
        
        let dictionary = dictionaries[0]
        if let messageString = dictionary[JSONKeysResponse.message.rawValue] as? String {
            self.message = messageString
            self.payload = nil
        } else {
            self.payload = dictionaries
            self.message = nil
        }
    }
}


