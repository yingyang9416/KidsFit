//
//  FirebaseDatabaseHelper.swift
//  KidsFit
//
//  Created by Steven Yang on 1/31/21.
//

import Foundation
import FirebaseDatabase

class FeedsModel: Decodable {
        var postId: String!
        var authorId: String! //The author of the post
        var timestamp: Double = 0.0 //We'll use it sort the posts.
        //And other properties like 'likesCount', 'postDescription'...
}

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
    
    func test() {
        let e = wodRef.child(currentGymId).queryOrderedByKey()
        
    }
    
//    class func getFeedsWith(lastKey: String?, completion: @escaping ((Bool, [FeedsModel]?) -> Void)) {
//            let feedsReference = Database.database().reference().child("YOUR FEEDS' NODE")
//            let query = (lastKey != nil) ? feedsReference.queryOrderedByKey().queryLimited(toLast: "YOUR NUMBER OF FEEDS PER PAGE" + 1).queryEnding(atValue: lastKey): feedsReference.queryOrderedByKey().queryLimited(toLast: "YOUR NUMBER OF FEEDS PER PAGE")
//            //Last key would be nil initially(for the first page).
//
//            query.observeSingleEvent(of: .value) { (snapshot) in
//                guard snapshot.exists(), let value = snapshot.value else {
//                    completion(false, nil)
//                    return
//                }
//                do {
//                    let model = try FirebaseDecoder().decode([String: FeedsModel].self, from: value)
//                    //We get the feeds in ['childAddedByAutoId key': model] manner. CodableFirebase decodes the data and we get our models populated.
//                    var feeds = model.map { $0.value }
//                    //Leaving the keys aside to get the array [FeedsModel]
//                    feeds.sort(by: { (P, Q) -> Bool in P.timestamp > Q.timestamp })
//                    //Sorting the values based on the timestamp, following recent first fashion. It is required because we may have lost the chronological order in the last steps.
//                    if lastKey != nil { feeds = Array(feeds.dropFirst()) }
//                    //Need to remove the first element(Only when the lastKey was not nil) because, it would be the same as the last one in the previous page.
//                    completion(true, feeds)
//                    //We get our data sorted and ready here.
//                } catch let error {
//                    print("Error occured while decoding - \(error.localizedDescription)")
//                    completion(false, nil)
//                }
//            }
//        }

    
    
    func fetchWOD(date: Date, gymId: String, onSuccess: @escaping (WOD?)->(), onFailure: @escaping (Error)->()) {
        let dateId = DateFormatter().dateString(from: date, format: .dateIdFormat)
        wodRef.child(gymId).child(dateId).observeSingleEvent(of: .value) { (snapshot) in
            if let value = snapshot.value as? [String: Any] {
                do {
                    let data = try JSONSerialization.data(withJSONObject: value, options: .prettyPrinted)
                    let wod = try JSONDecoder().decode(WOD?.self, from: data)
                    onSuccess(wod)
                } catch {
                    print("errors decode the data")
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
