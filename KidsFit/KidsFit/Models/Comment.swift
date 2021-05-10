//
//  Comment.swift
//  KidsFit
//
//  Created by Steven Yang on 2/10/21.
//

import Foundation

enum commentType: String {
    case wod = "wod"
    case post = "post"
}

struct WODComment: Codable {
    var id: String?
    var content: String
    var timeString: String
    var userId: String
    var wodId: String?
    var gymId: String?
    
    var firebaseDictionary: [String: Any] {
        var result = [String: Any]()
        result["content"] = content
        result["timeString"] = timeString
        result["userId"] = userId
        result.addIfNotNil(key: FirebaseKey.gymId, value: gymId)
        result.addIfNotNil(key: FirebaseKey.wodId, value: wodId)

        return result
    }
    
    var time: Date? {
        return DateFormatter().date(from: timeString, format: .fromJson)
    }
    
}

struct PostComment: Codable {
    var content: String
    var timeString: String
    var userId: String
}
