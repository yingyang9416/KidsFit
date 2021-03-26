//
//  FirebaseDatabaseHelper.swift
//  KidsFit
//
//  Created by Steven Yang on 1/31/21.
//

import Foundation
import FirebaseDatabase
import FirebaseStorage

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
    private lazy var storageRef = Storage.storage().reference()
    private lazy var userRef = databaseRef.child("User")
    private lazy var wodRef = databaseRef.child("WOD")
    private lazy var wodCommentRef = databaseRef.child("WODComment")
    private lazy var postRef = databaseRef.child("Post")
    private lazy var postImageStorageRef = storageRef.child("PostImage")


    func insertUser(uid:String, userDictionary: [String: Any], onSuccess: @escaping ()->(), onFailure: @escaping (Error)->()){
        userRef.child(uid).updateChildValues(userDictionary) { (error, dbRef) in
            if let error = error {
                onFailure(error)
            } else {
                onSuccess()
            }
        }
    }
    
    func fetchUser(uid: String, onSuccess: @escaping (User?)->(), onFailure: @escaping (Error)->()) {
        userRef.child(uid).observeSingleEvent(of: .value) { (snapshot) in
            if let value = snapshot.value as? [String: Any] {
                do {
                    let data = try JSONSerialization.data(withJSONObject: value, options: .prettyPrinted)
                    let user = try JSONDecoder().decode(User?.self, from: data)
                    user?.userId = uid
                    onSuccess(user)
                } catch {
                    print("errors decode the data")
                }
            } else { // found nil value
                onSuccess(nil)
            }
        }
        
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
    
    func fetchWODComments(date: Date, gymId: String, onSuccess: @escaping ([WODComment])->(), onFailure: @escaping (Error)->()) {
        var comments = [WODComment?]()
        let wodId = DateFormatter().timeString(from: date, format: .dateIdFormat)
        wodRef.child(gymId).child(wodId).child("Comments").observeSingleEvent(of: .value) { (snapshot) in
            let group = DispatchGroup()
            if let values = snapshot.value as? [String: Any]{
                for v in values {
                    group.enter()
                    self.fetchWODComment(commentId: v.key) { (comment) in
                        comments.append(comment)
                        group.leave()
                    } onFailure: { (_) in
                        print("error fetching comment")
                        group.leave()
                    }

                }
            }
            group.notify(queue: .global(qos: .userInitiated)) {
                let filtered = comments.compactMap { $0 }
                onSuccess(filtered)
            }
        }
    }
    
    func fetchWODComment(commentId: String, onSuccess: @escaping (WODComment?)->(), onFailure: @escaping (Error)->()) {
        wodCommentRef.child(commentId).observeSingleEvent(of: .value) { (snapshot) in
            if let value = snapshot.value as? [String: Any] {
                do {
                    let data = try JSONSerialization.data(withJSONObject: value, options: .prettyPrinted)
                    let comment = try JSONDecoder().decode(WODComment?.self, from: data)
                    onSuccess(comment)
                } catch {
                    print("errors decode the comment data")
                }
            } else { // found nil value
                onSuccess(nil)
            }
        }
    }
    
    func fetchAllPosts(onSuccess: @escaping ([Post])->(), onFailure: @escaping (Error)->()) {
        postRef.observeSingleEvent(of: .value) { (snapshot) in
            let group = DispatchGroup()
            var posts = [Post?]()
            if let values = snapshot.value as? [String : Any] {
                for v in values {  // post id: v.key
                    group.enter()
                    self.fetchPost(id: v.key) { (post) in
                        posts.append(post)
                        group.leave()
                    } onFailure: { (_) in
                        group.leave()
                    }
                }
            }
            group.notify(queue: .global(qos: .userInitiated)) {
                let compactPosts = posts.compactMap { $0 }
                onSuccess(compactPosts)
            }
        }
    }
    
    func fetchPost(id: String, onSuccess: @escaping (Post?)->(), onFailure: @escaping (Error)->()) {
        postRef.child(id).observeSingleEvent(of: .value) { (snapshot) in
            if let value = snapshot.value as? [String: Any] {
                do {
                    let data = try JSONSerialization.data(withJSONObject: value, options: .prettyPrinted)
                    var post = try JSONDecoder().decode(Post?.self, from: data)
                    post?.id = id
                    onSuccess(post)
                } catch {
                    print("errors decode the post data")
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
    
    func insertWODComment(gymId: String, wodId: String, comment: WODComment, onSuccess: @escaping ()->(), onFailure: @escaping (Error)->()) {
        guard let key = wodCommentRef.childByAutoId().key else {
            onFailure(AppError.otherError)
            return
        }
        let group = DispatchGroup()
        var finalError: Error?
        group.enter()
        wodCommentRef.child(key).updateChildValues(comment.firebaseDictionary) { (error, _) in
            finalError = error == nil ? finalError : error
            group.leave()
        }
        group.enter()
        wodRef.child(gymId).child(wodId).child("Comments").updateChildValues([key: "CommentId"]) { (error, _) in
            finalError = error == nil ? finalError : error
            group.leave()
        }
        
        group.notify(queue: .global(qos: .userInitiated)) {
            if let error = finalError {
                onFailure(error)
            } else {
                onSuccess()
            }
        }
    }
    
    func insertPostImage(_ image: UIImage, postId: String, onSuccess: @escaping (URL?)->(), onFailure: @escaping (Error)->()) {
        guard let data = UIImage.jpegData(image)(compressionQuality: 0.3) else {
            onFailure(AppError.otherError)
            return
        }
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpeg"
        let imagename = "\(postId).jpeg"
        
        postImageStorageRef.child(imagename).putData(data, metadata: metaData) { (metaData, error) in
            if error == nil {
                self.postImageStorageRef.child(imagename).downloadURL { (url, urlError) in
                    urlError == nil ? onSuccess(url) : onFailure(urlError!)
                }
            } else {
                onFailure(error!)
            }
        }
    }
    
    func insertPost(image: UIImage?, post: Post, onSuccess: @escaping ()->(), onFailure: @escaping (Error)->()) {
        guard let key = postRef.childByAutoId().key else {
            onFailure(AppError.otherError)
            return
        }
        
        if let imageToUpload = image {
            insertPostImage(imageToUpload, postId: key) { (url) in
                if let imageUrl = url {
                    var dict = post.firebaseDictionary
                    dict["imageUrlString"] = "\(imageUrl)"
                    self.postRef.child(key).updateChildValues(dict)
                    onSuccess()
                }
            } onFailure: { (error) in
                onFailure(error)
            }

        } else {
            postRef.child(key).updateChildValues(post.firebaseDictionary) { (error, _) in
                error == nil ? onSuccess() : onFailure(error!)
            }
        }

    }
    
}
