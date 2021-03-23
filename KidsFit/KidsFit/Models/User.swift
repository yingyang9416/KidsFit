//
//  User.swift
//  KidsFit
//
//  Created by Steven Yang on 2/7/21.
//

import Foundation

class User: Codable {
    var firstName: String
    var lastName: String
    var email: String
    var userId: String?
    
    init(firstName: String, lastName: String, email: String, userId: String?) {
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.userId = userId
    }
}
