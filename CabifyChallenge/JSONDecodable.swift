//
//  JSONDecodable.swift
//  CabifyChallenge
//
//  Created by Alberto on 8/10/16.
//  Copyright © 2016 aortegas. All rights reserved.
//

import Foundation

typealias JSONDictionary = [String: AnyObject]

protocol JSONDecodable
{
    init?(dictionaries: [JSONDictionary])
}


// MARK: Methods
func decode<T: JSONDecodable>(data: NSData) -> T? {
    
    guard let JSONObject = try? NSJSONSerialization.JSONObjectWithData(data, options: []) else {
        return nil
    }

    if let JSONDictionaries = JSONObject as? [JSONDictionary] {
        return T(dictionaries: JSONDictionaries)
    }
    
    if let JSONDictionary = JSONObject as? JSONDictionary {
        return T(dictionaries: [JSONDictionary])
    }
    
    return nil
}

func decode<T: JSONDecodable>(dictionaries: [JSONDictionary]) -> [T]? {
    return dictionaries.flatMap { T(dictionaries: [$0]) }
}
