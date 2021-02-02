//
//  FirebaseDatabaseHelper.swift
//  KidsFit
//
//  Created by Steven Yang on 1/31/21.
//

import Foundation
import FirebaseDatabase

class FirebaseDatabaseHelper: NSObject {
    static let shared = FirebaseDatabaseHelper()
    private override init(){}

    private lazy var databaseRef = Database.database().reference()
    private lazy var userRef = databaseRef.child("User")
    private lazy var wodRef = databaseRef.child("WOD")


    func insertUser(uid:String, userDictionary: [String: Any], onSuccess: @escaping ()->(), onFailure: @escaping (Error)->()){
        userRef.child(uid).updateChildValues(userDictionary) { (error, dbRef) in
            if let error = error {
                onFailure(error)
            } else {
                onSuccess()
            }
        }
    }
    
    func fetchWOD(date: Date, gymId: String, onSuccess: @escaping (WOD?)->(), onFailure: @escaping (Error)->()) {
        let dateId = DateFormatter().dateString(from: date, format: .dateIdFormat)
        wodRef.child(gymId).child(dateId).observeSingleEvent(of: .value) { (snapshot) in
            if let value = snapshot.value {
                do {
                    let data = try JSONSerialization.data(withJSONObject: value, options: .prettyPrinted)
                    let wod = try JSONDecoder().decode(WOD?.self, from: data)
                    onSuccess(wod)
                } catch {
                    
                }
            } else { // found nil value
                onSuccess(nil)
            }
            
            
        }
    }

    // insert WOD content (Workout of the day)
    func insertWOD(gymId: String, workout: String, date: Date, onSuccess: @escaping ()->(), onFailure: @escaping (Error)->()) {
        let valueDictionary = ["workout": workout]
        let dateId = DateFormatter().dateString(from: date, format: .dateIdFormat)
        wodRef.child(gymId).child(dateId).updateChildValues(valueDictionary) { (error, dbRef) in
            if let error = error {
                onFailure(error)
            } else {
                onSuccess()
            }
        }
        
    }
    
}
