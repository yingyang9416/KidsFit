//
//  FirebaseObject.swift
//  KidsFit
//
//  Created by Steven Yang on 2/10/21.
//

import Foundation

protocol FirebaseObject {
    var firebaseJson: [String: Any] { get }
    var path: String { get }
}
