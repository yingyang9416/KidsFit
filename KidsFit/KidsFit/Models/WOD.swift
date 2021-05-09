//
//  WOD.swift
//  KidsFit
//
//  Created by Steven Yang on 2/1/21.
//

import Foundation

struct WOD: Codable {
    var gymId: String?
    var date: Date?
    var title: String?
    var workout: String
    var dateString: String?
    var videoId: String?
    
    var firebaseDictionary: [String: Any] {
        var result = [String: Any]()
        result.addIfNotNil(key: FirebaseKey.gymId, value: gymId)
        result.addIfNotNil(key: FirebaseKey.dateString, value: dateString)
        result.addIfNotNil(key: FirebaseKey.workout, value: workout)
        if let title = title, !title.isEmpty {
            result[FirebaseKey.title] = title
        }
        if let vid = videoId, !vid.isEmpty {
            result[FirebaseKey.videoId] = vid
        }
        return result
    }
}
