//
//  Post.swift
//  KidsFit
//
//  Created by Steven Yang on 3/23/21.
//

import Foundation
import UIKit

struct Post: Codable {
    var imageUrlString: String?
    var text: String
    var timeString: String
    var userId: String
    var id: String?
    
    var firebaseDictionary: [String: Any] {
        var result = [String: Any]()
        result["text"] = text
        result["timeString"] = timeString
        result["userId"] = userId
        return result
    }
    
    var date: Date? {
        DateFormatter().date(from: timeString, format: .fromJson)
    }
}
