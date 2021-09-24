//
//  DictionaryExtensions.swift
//  HiconMultiScreen
//
//  Created by user on 2020/11/16.
//  Copyright © 2020 HICON. All rights reserved.
//

import Foundation

// MARK: - Methods
extension Dictionary {
    /// Checks if a key exists in the dictionary.
    func has(_ key: Key) -> Bool {
        return index(forKey: key) != nil
    }
}

extension Dictionary where Value: Equatable {
    /// Difference of self and the input dictionaries.
    /// Two dictionaries are considered equal if they contain the same [key: value] pairs.
    func difference(_ dictionaries: [Key: Value]...) -> [Key: Value] {
        var result = self
        for dictionary in dictionaries {
            for (key, value) in dictionary {
                if result.has(key) && result[key] == value {
                    result.removeValue(forKey: key)
                }
            }
        }
        return result
    }
}

/// Combines the first dictionary with the second and returns single dictionary.
func += <KeyType, ValueType> (left: inout [KeyType: ValueType], right: [KeyType: ValueType]) {
    for (k, v) in right {
        left.updateValue(v, forKey: k)
    }
}

/// Difference operator.
func - <K, V: Equatable> (first: [K: V], second: [K: V]) -> [K: V] {
    return first.difference(second)
}
