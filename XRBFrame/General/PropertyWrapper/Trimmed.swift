//
//  Trimmed.swift
//  HiconMultiScreen
//
//  Created by devchena on 2021/7/19.
//

import Foundation

@propertyWrapper
struct Trimmed {
    private var value: String = ""

    var wrappedValue: String {
        get { value }
        set { value = newValue.trimmingCharacters(in: .whitespacesAndNewlines) }
    }

    init(wrappedValue initialValue: String) {
        wrappedValue = initialValue
    }
}
