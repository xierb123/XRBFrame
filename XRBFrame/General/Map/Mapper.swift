//
//  Mapper.swift
//  HiconMultiScreen
//
//  Created by user on 2020/11/16.
//  Copyright © 2020 HICON. All rights reserved.
//

import Foundation
import CleanJSON

public enum MapError: Error {
    case dataToModelFailed
    case dataToJSONFailed
    case dataToJSONStringFailed
    case jsonToModelFailed
    case jsonToDataFailed
    case jsonArrayToDataFailed
    case jsonStringToDataFailed
}

public enum Mapper<T: Codable> {
    /// Maps a JSON dictionary to an object that conforms to Codable
    public static func map(json: [String: Any]) throws -> T {
        guard let data = try? json.toData() else {
            print("Mapper(\(#function)) json to data failed")
            throw MapError.jsonToDataFailed
        }
        return try map(data: data)
    }

    /// Maps a JSON string to an object that conforms to Codable
    public static func map(jsonString: String) throws -> T {
        guard let data = jsonString.data(using: .utf8) else {
            print("Mapper(\(#function)) json to data failed")
            throw MapError.jsonToDataFailed
        }
        return try map(data: data)
    }

    /// Maps a Data object to a Codable object
    public static func map(data: Data) throws -> T {
        do {
            let decoder = CleanJSONDecoder()
            let obj = try decoder.decode(T.self, from: data)
            return obj
        } catch {
            print("Mapper(\(#function)) map failed: " + error.localizedDescription)
            throw MapError.dataToModelFailed
        }
    }

    /// Maps a JSON object to a Codable object if it is a JSON dictionary or String, or returns nil.
    public static func map(jsonObject: Any) throws -> T {
        if let jsonString = jsonObject as? String {
            return try map(jsonString: jsonString)
        } else if let dict = jsonObject as? [String: Any] {
            return try map(json: dict)
        } else if let data = jsonObject as? Data {
            return try map(data: data)
        }
        print("Mapper(\(#function)) map failed")
        throw MapError.jsonToModelFailed
    }

    /// Maps a Data object to an array of Codable objects.
    public static func mapArray(data: Data) throws -> [T] {
        let decoder = CleanJSONDecoder()
        do {
            let objs = try decoder.decode([T].self, from: data)
            return objs
        } catch {
            print("Mapper(\(#function)) map array failed: " + error.localizedDescription)
            throw MapError.dataToModelFailed
        }
    }

    /// Maps an array of JSON dictionary to an array of Codable objects.
    public static func mapArray(jsonArray: [[String: Any]]) throws -> [T] {
        guard let data = try? jsonArray.toData() else {
            print("Mapper(\(#function)) json to data failed")
            throw MapError.jsonArrayToDataFailed
        }
        return try mapArray(data: data)
    }
}
