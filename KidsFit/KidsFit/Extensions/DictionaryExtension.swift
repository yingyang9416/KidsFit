//
//  DictionaryExtension.swift
//  KidsFit
//
//  Created by Steven Yang on 5/8/21.
//

import Foundation

extension Dictionary {
    mutating func addIfNotNil(key: Key, value: Value?) {
        if let value = value {
            self[key] = value
        }
    }
}
