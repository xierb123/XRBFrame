//
//  URLExtensions.swift
//  HiconMultiScreen
//
//  Created by user on 2020/11/16.
//  Copyright © 2020 HICON. All rights reserved.
//

import UIKit

// MARK: - Properties
extension URL {
    /// Dictionary of the URL's query parameters.
    var queryParameters: [String: String]? {
        guard let components = URLComponents(url: self, resolvingAgainstBaseURL: false), let queryItems = components.queryItems else {
            return nil
        }
        var items: [String: String] = [:]
        for queryItem in queryItems {
            items[queryItem.name] = queryItem.value
        }
        return items
    }
}

// MARK: - Methods
extension URL {
    /// URL encoded.
    func encoded() -> String {
        return absoluteString.encoded()
    }
    
    /// URL decoded.
    func decoded() -> String {
        return absoluteString.decoded()
    }
}

extension URL {
    /// URL with appending query parameters.
    ///
    ///        let url = URL(string: "https://google.com")!
    ///        let param = ["q": "Swifter Swift"]
    ///        url.appendingQueryParameters(params) -> "https://google.com?q=Swifter%20Swift"
    ///
    /// - Parameter parameters: parameters dictionary.
    /// - Returns: URL with appending given query parameters.
    func appendingQueryParameters(_ parameters: [String: String]) -> URL {
        guard var urlComponents = URLComponents(url: self, resolvingAgainstBaseURL: true) else {
            return self
        }
        var items = urlComponents.queryItems ?? []
        items += parameters.map({ URLQueryItem(name: $0, value: $1) })
        urlComponents.queryItems = items
        return urlComponents.url ?? self
    }
    
    /// Append query parameters to URL.
    ///
    ///        var url = URL(string: "https://google.com")!
    ///        let param = ["q": "Swifter Swift"]
    ///        url.appendQueryParameters(params)
    ///        print(url) // prints "https://google.com?q=Swifter%20Swift"
    ///
    /// - Parameter parameters: parameters dictionary.
    mutating func appendQueryParameters(_ parameters: [String: String]) {
        self = appendingQueryParameters(parameters)
    }
    
    /// URL with deleting query parameters.
    ///
    ///        let url = URL(string: "https://google.com?q=Swifter%20Swift")!
    ///        let keys = ["q"]
    ///        url.deletingQueryParameters(byKeys: keys) -> "https://google.com"
    ///
    /// - Parameter keys: keys of deleted query parameters.
    /// - Returns: URL with deleting query parameters by given keys.
    func deletingQueryParameters(byKeys keys: [String]) -> URL {
        guard var urlComponents = URLComponents(url: self, resolvingAgainstBaseURL: true) else {
            return self
        }
        var items = urlComponents.queryItems ?? []
        for (index, item) in items.enumerated() {
            if keys.contains(item.name) {
                items.remove(at: index)
            }
        }
        urlComponents.queryItems = items.isEmpty ? nil : items
        return urlComponents.url ?? self
    }

    /// Delete query parameters to URL.
    ///
    ///        let url = URL(string: "https://google.com?q=Swifter%20Swift")!
    ///        let keys = ["q"]
    ///        url.deletingQueryParameters(byKeys: keys)
    ///        print(url) // prints "https://google.com"
    ///
    /// - Parameter keys: keys of deleted query parameters.
    mutating func deleteQueryParameters(byKeys keys: [String]) {
        self = deletingQueryParameters(byKeys: keys)
    }
    
    /// Get value of a query key.
    ///
    ///    var url = URL(string: "https://google.com?code=12345")!
    ///    queryValue(for: "code") -> "12345"
    ///
    /// - Parameter key: The key of a query value.
    func queryValue(for key: String) -> String? {
        guard let items = URLComponents(string: absoluteString)?.queryItems else {
            return nil
        }
        for item in items where item.name == key {
            return item.value
        }
        return nil
    }
    
    /// Returns a new URL by removing all the path components.
    ///
    ///     let url = URL(string: "https://domain.com/path/other")!
    ///     print(url.deletingAllPathComponents()) // prints "https://domain.com/"
    ///
    /// - Returns: URL with all path components removed.
    func deletingAllPathComponents() -> URL {
        var url: URL = self
        for _ in 0..<pathComponents.count - 1 {
            url.deleteLastPathComponent()
        }
        return url
    }
    
    /// Remove all the path components from the URL.
    ///
    ///        var url = URL(string: "https://domain.com/path/other")!
    ///        url.deleteAllPathComponents()
    ///        print(url) // prints "https://domain.com/"
    mutating func deleteAllPathComponents() {
        for _ in 0..<pathComponents.count - 1 {
            deleteLastPathComponent()
        }
    }
    
    /// Generates new URL that does not have scheme.
    ///
    ///        let url = URL(string: "https://domain.com")!
    ///        print(url.droppedScheme()) // prints "domain.com"
    func droppedScheme() -> URL? {
        if let scheme = scheme {
            let droppedScheme = String(absoluteString.dropFirst(scheme.count + 3))
            return URL(string: droppedScheme)
        }
        
        guard host != nil else {
            return self
        }
        
        let droppedScheme = String(absoluteString.dropFirst(2))
        return URL(string: droppedScheme)
    }
}
