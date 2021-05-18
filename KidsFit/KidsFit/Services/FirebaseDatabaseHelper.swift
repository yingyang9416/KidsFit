//
//  FirebaseDatabaseHelper.swift
//  KidsFit
//
//  Created by Steven Yang on 1/31/21.
//

import Foundation
import FirebaseDatabase
import FirebaseStorage

class FirebaseDatabaseHelper: NSObject {
    static let shared = FirebaseDatabaseHelper()
    private override init(){}

    private lazy var databaseRef = Database.database(url: Environment.rootDatabaseURL).reference()
    private lazy var storageRef = Storage.storage(url: Environment.rootStorageURL).reference()
    private lazy var userRef = databaseRef.child("User")
    private lazy var gymRef = databaseRef.child("Gym")
    private lazy var wodRef = databaseRef.child("WOD")
    private lazy var wodCommentRef = databaseRef.child("WODComment")
    private lazy var postRef = databaseRef.child("Post")
    private lazy var postImageStorageRef = storageRef.child("PostImage")
    private lazy var profileImageStorageRef = storageRef.child("ProfileImage")


    func insertUser(uid:String, userDictionary: [String: Any], onSuccess: @escaping ()->(), onFailure: @escaping (Error)->()){
        userRef.child(uid).updateChildValues(userDictionary) { (error, dbRef) in
            if let error = error {
                onFailure(error)
            } else {
                onSuccess()
            }
        }
    }
    
    func updateMyInfo(user: User, onSuccess: @escaping ()->(), onFailure: @escaping (Error)->()) {
        guard let uid = user.userId else {
            onFailure(AppError.noUserError)
            return
        }
        
        userRef.child(uid).updateChildValues(user.firebaseDictionary) { (error, _) in
            if let error = error {
                onFailure(error)
            } else {
                do {
                    try UserDefaults.standard.setObject(user, forKey: savedUser)
                } catch {
                    print("Failed to set userdefaults")
                }
                onSuccess()
            }
        }
    }
    
    func upsertProfileImage(image: UIImage, user: User, onSuccess: @escaping (URL?)->(), onFailure: @escaping (Error)->()) {
        guard let uid = user.userId, let data = UIImage.jpegData(image)(compressionQuality: 0.3) else {
            onFailure(AppError.noUserError)
            return
        }
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpeg"
        let imagename = "\(uid).jpeg"
        
        profileImageStorageRef.child(imagename).putData(data, metadata: metaData) { (metaData, error) in
            if error == nil {
                self.profileImageStorageRef.child(imagename).downloadURL { (url, urlError) in
                    if let imageUrl = url, let uid = user.userId {
                        var dict = user.firebaseDictionary
                        dict["profileImageUrlString"] = "\(imageUrl)"
                        self.userRef.child(uid).updateChildValues(dict)
                    }
                    urlError == nil ? onSuccess(url) : onFailure(urlError!)
                }
            } else {
                onFailure(error!)
            }
        }

    }
    
    func fetchGymInfo(gymId: String, completion: @escaping (Result<Gym?, Error>)->()) {
        gymRef.child(gymId).observeSingleEvent(of: .value) { (snapshot) in
            if let value = snapshot.value as? [String: Any] {
                do {
                    let data = try JSONSerialization.data(withJSONObject: value, options: .prettyPrinted)
                    var gym = try JSONDecoder().decode(Gym?.self, from: data)
                    gym?.id = gymId
                    completion(.success(gym))
                } catch {
                    completion(.failure(AppError.otherError))
                    print("errors decode the data")
                }
            } else { // found nil value
                completion(.success(nil))
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
                    onFailure(AppError.otherError)
                }
            } else { // found nil value
                onSuccess(nil)
            }
        }
    }
    
    func fetchWODsWithVideo(gymId: String, completion: @escaping (Result<[WOD], Error>)->()) {
        
        wodRef.child(gymId).observeSingleEvent(of: .value) { (snapshot) in
            let group = DispatchGroup()
            var wods = [WOD?]()
            if let values = snapshot.value as? [String : Any] {
                for v in values {  // wod id: v.key
                    group.enter()
                    if let date = DateFormatter().date(from: v.key, format: .dateIdFormat) {
                        self.fetchWOD(date: date, gymId: gymId) { (wod) in
                            wods.append(wod)
                            group.leave()
                        } onFailure: { (_) in
                            group.leave()
                        }

                    } else {
                        group.leave()
                    }
                }
            }
            group.notify(queue: .global(qos: .userInitiated)) {
                let compactWods = wods.compactMap { $0 }.filter { $0.videoId != nil }.sorted { $0.dateString > $1.dateString }
                completion(.success(compactWods))
            }
        }
    }
    
    func fetchWODComments(date: Date, gymId: String, onSuccess: @escaping ([WODComment])->(), onFailure: @escaping (Error)->()) {
        var comments = [WODComment?]()
        let wodId = DateFormatter().timeString(from: date, format: .dateIdFormat)
        wodRef.child(gymId).child(wodId).child(FirebaseKey.comments).observeSingleEvent(of: .value) { (snapshot) in
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
                let filtered = comments.compactMap { $0 }.sorted { $0.timeString > $1.timeString }
                onSuccess(filtered)
            }
        }
    }
    
    func fetchWODComment(commentId: String, onSuccess: @escaping (WODComment?)->(), onFailure: @escaping (Error)->()) {
        wodCommentRef.child(commentId).observeSingleEvent(of: .value) { (snapshot) in
            if let value = snapshot.value as? [String: Any] {
                do {
                    let data = try JSONSerialization.data(withJSONObject: value, options: .prettyPrinted)
                    var comment = try JSONDecoder().decode(WODComment?.self, from: data)
                    comment?.id = commentId
                    onSuccess(comment)
                } catch {
                    print("errors decode the comment data")
                }
            } else { // found nil value
                onSuccess(nil)
            }
        }
    }
    
    func fetchposts(lastKey: String?, onSuccess: @escaping ([Post])->(), onFailure: @escaping (Error)->()) {
        let query = (lastKey == nil) ? postRef.queryOrdered(byChild: "timeString").queryLimited(toLast: 8) : postRef.queryOrdered(byChild: "timeString").queryLimited(toLast: 8).queryEnding(beforeValue: lastKey)

        query.observeSingleEvent(of: .value) { (snapshot) in
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
                let compactPosts = posts.compactMap { $0 }.sorted { $0.timeString > $1.timeString }
                onSuccess(compactPosts)
            }
        }
    }
    
    func fetchMyPosts(completion: @escaping (Result<[Post], Error>)->()) {
        guard let uid = UserDefaults.currentUser()?.userId else {
            completion(.failure(AppError.noUserError))
            return
        }
        let query = postRef.queryOrdered(byChild: "userId").queryEnding(atValue: uid).queryStarting(atValue: uid)
        
        query.observeSingleEvent(of: .value) { (snapshot) in
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
                let compactPosts = posts.compactMap { $0 }.sorted { $0.timeString > $1.timeString }
                completion(.success(compactPosts))
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
    
    func upsert(wod: WOD, completion: @escaping (Result<(), Error>)->()) {
        guard let gymId = wod.gymId, let date = wod.date else {
            completion(.failure(AppError.otherError))
            return
        }
        let dateId = DateFormatter().dateString(from: date, format: .dateIdFormat)
        wodRef.child(gymId).child(dateId).updateChildValues(wod.firebaseDictionary) { (error, _) in
            error == nil ? completion(.success(())) : completion(.failure(error!))
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
        wodRef.child(gymId).child(wodId).child(FirebaseKey.comments).updateChildValues([key: FirebaseKey.commentId]) { (error, _) in
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
        
        guard image != nil else {
            onFailure(AppError.otherError)
            return
        }
        
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
    
    func fetchLikes(for comment: WODComment, completion: @escaping (Result<[String], Error>)->()) {
        guard let id = comment.id else {
            return
        }
        wodCommentRef.child(id).child(FirebaseKey.likes).observeSingleEvent(of: .value) { (snapshot) in
            if let value = snapshot.value as? [String: Any] {
                let s = Array(value.keys)
                completion(.success(s))
            } else { // found nil value
                completion(.success([]))
            }
        }
    }
    
    func fetchLikes(for post: Post, completion: @escaping (Result<[String], Error>)->()) {
        guard let id = post.id else {
            return
        }
        postRef.child(id).child(FirebaseKey.likes).observeSingleEvent(of: .value) { (snapshot) in
            if let value = snapshot.value as? [String: Any] {
                let s = Array(value.keys)
                completion(.success(s))
            } else { // found nil value
                completion(.success([]))
            }
        }

    }
    
    func likeWODComment(like: Bool, comment: WODComment) {
        guard let id = comment.id, let uid = UserDefaults.currentUser()?.userId else {
            return
        }
        if like {
            let dict: [String: Any] = [uid: FirebaseKey.userId]
            wodCommentRef.child(id).child(FirebaseKey.likes).updateChildValues(dict)
        } else {
            wodCommentRef.child(id).child(FirebaseKey.likes).child(uid).removeValue()
        }
    }
    
    func likePost(like: Bool, post: Post) {
        guard let id = post.id, let uid = UserDefaults.currentUser()?.userId else {
            return
        }
        if like {
            let dict: [String: Any] = [uid: FirebaseKey.userId]
            postRef.child(id).child(FirebaseKey.likes).updateChildValues(dict)
        } else {
            postRef.child(id).child(FirebaseKey.likes).child(uid).removeValue()
        }
    }
    
}
