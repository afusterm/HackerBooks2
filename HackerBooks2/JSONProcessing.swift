//
//  JSONProcessing.swift
//  HackerBooks
//
//  Created by Alejandro on 06/07/16.
//  Copyright © 2016 Alejandro. All rights reserved.
//

import Foundation
import CoreData

typealias JSONObject = AnyObject
typealias JSONDictionary = [String: JSONObject]
typealias JSONArray = [JSONDictionary]

/**
    Converts a comma separated value string to an array of strings.
 
    - Parameter string: String with values separated with commas. Ex: "algorithms,html,java"
 
    - Returns: Array with every single item from the string. Ex: ["algorithms", "html", "java"]
 */
func arrayFrom(string csv: String) -> [String] {
    var array = [String]()
    
    csv.components(separatedBy: ",").forEach { (t: String) in
        array.append(t.trimmingCharacters(in: CharacterSet.whitespaces))
    }
    
    return array
}

func read(fromJSON json: URL) throws -> JSONArray {
    var array = JSONArray()
    let data = try Data(contentsOf: json)
    let jsonObjects = try? JSONSerialization.jsonObject(with: data)
    if let jsonArray = jsonObjects as? JSONArray {
        array = jsonArray
    }
    
    return array
}
