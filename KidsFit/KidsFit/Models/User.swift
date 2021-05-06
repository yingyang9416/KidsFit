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
    var profileImageUrlString: String?
    var admin: String?
    var isAdmin: Bool {
        return admin == "YES"
    }
    
    init(firstName: String, lastName: String, email: String, userId: String?) {
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.userId = userId
    }
    
    var firebaseDictionary: [String: Any] {
        var result = [String: Any]()
        result["firstName"] = firstName
        result["lastName"] = lastName
        result["email"] = email
        return result
    }
}
