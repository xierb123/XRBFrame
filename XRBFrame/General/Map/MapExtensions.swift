//
//  MapExtensions.swift
//  HiconMultiScreen
//
//  Created by user on 2020/11/16.
//  Copyright © 2020 HICON. All rights reserved.
//

import Foundation

public extension Encodable {
    /// Returns the JSON dictionary for the object
    func toJSON() throws -> [String: Any] {
        return try toData().toJSON()
    }

    /// Returns the JSON String for the object
    func toJSONString() throws -> String {
        return try toData().toJSONString()
    }
    
    /// Returns the Data for the object
    func toData() throws -> Data {
        return try JSONEncoder().encode(self)
    }
}

public extension Array where Element: Encodable {
    /// Returns the JSON Array for the object
    func toJSON() throws -> [[String: Any]] {
        return try map {
            // convert every element in array to JSON dictionary equivalent
            try $0.toJSON()
        }
    }
}

public extension Array where Element == Dictionary<String, Any> {
    /// Returns the Data object for the object
    func toData(_ options: JSONSerialization.WritingOptions = []) throws -> Data {
        return try JSONSerialization.data(withJSONObject: self, options: options)
    }

    /// Returns the JSON String for the object
    func toJSONString(_ options: JSONSerialization.WritingOptions = []) throws -> String {
        return try toData(options).toJSONString()
    }
}

 public extension Dictionary {
    /// Returns the Data object for the object
    func toData(_ options: JSONSerialization.WritingOptions = []) throws -> Data {
        return try JSONSerialization.data(withJSONObject: self, options: options)
    }

    /// Returns the JSON String for the object
    func toJSONString(_ options: JSONSerialization.WritingOptions = []) throws -> String {
        return try toData(options).toJSONString()
    }
}

public extension String {
    /// Returns the JSON dictionary for the object
    func toJSON(_ options: JSONSerialization.ReadingOptions = []) throws -> [String: Any]? {
        if let data = data(using: .utf8) {
            return try data.toJSON(options)
        } else {
            throw MapError.jsonStringToDataFailed
        }
    }
}

public extension Data {
    /// Returns the JSON dictionary for the object
    func toJSON(_ options: JSONSerialization.ReadingOptions = []) throws -> [String: Any] {
        let jsonObject = try JSONSerialization.jsonObject(with: self, options: options)
        if let json = jsonObject as? [String: Any] {
            return json
        } else {
            throw MapError.dataToJSONFailed
        }
    }

    /// Returns the JSON String for the object
    func toJSONString() throws -> String {
        if let jsonString = String(data: self, encoding: .utf8) {
            return jsonString
        } else {
            throw MapError.dataToJSONStringFailed
        }
    }
}
