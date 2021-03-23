//
//  FirebaseAuth.swift
//  KidsFit
//
//  Created by Steven Yang on 1/30/21.
//

import Foundation
import FirebaseAuth

let isUserLoggedIn = "isUserLoggedIn"
let savedUser = "savedUser"

class FirebaseAuth: NSObject{
    static let shared = FirebaseAuth()
    private override init(){}
    
    //private lazy var currentUser = CurrentUser.sharedInstance

    
    func signupUser(email: String, userDict: [String: Any], password: String, onSuccess: @escaping ()->(), onFailure: @escaping (Error)->()) {
        Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
            if let error = error {
                onFailure(error)
            } else if let uid = authResult?.user.uid {
                FirebaseDatabaseHelper.shared.insertUser(uid: uid, userDictionary: userDict) {
                    onSuccess()
                    do {
                        let data = try JSONSerialization.data(withJSONObject: userDict, options: .prettyPrinted)
                        let user = try JSONDecoder().decode(User?.self, from: data)
                        user?.userId = uid
                        try UserDefaults.standard.setObject(user, forKey: savedUser)
                        UserDefaults.standard.set(true, forKey: isUserLoggedIn)
                    } catch {
                        print("errors decode the data")
                    }
                } onFailure: { (error) in
                    onFailure(error)
                }

            }
        }
    }
    
    func loginUser(email: String, password: String, onSuccess: @escaping ()->(), onFailure: @escaping (Error)->()) {
        Auth.auth().signIn(withEmail: email, password: password) { (authResult, error) in
            if error == nil, let userId = Auth.auth().currentUser?.uid {
                FirebaseDatabaseHelper.shared.fetchUser(uid: userId) { (user) in
                    guard let user = user else {
                        onFailure(AppError.noUserError)
                        return
                    }
                    do {
                        try UserDefaults.standard.setObject(user, forKey: savedUser)
                        UserDefaults.standard.set(true, forKey: isUserLoggedIn)
                        print("set flag")
                    } catch {
                        print("Failed to set userdefaults")
                    }
                    onSuccess()
                } onFailure: { (error) in
                    onFailure(error)
                }

            } else {
                onFailure(error ?? AppError.loginError)
            }
        }
    }
        
    
    
//    func sendPwdResetLink(email: String){
//        Auth.auth().sendPasswordReset(withEmail: email) { (error) in
//            if error != nil {
//                TWMessageBarManager.sharedInstance().showMessage(withTitle: "ERROR", description: error?.localizedDescription, type: .error, duration: 5.0)
//
//            } else {
//                TWMessageBarManager.sharedInstance().showMessage(withTitle: "Test", description: "Check your email", type: .success, duration: 5.0)
//            }
//        }
//    }
    
//    func signout(completion:()->()){
//        do {
//            try Auth.auth().signOut()
//            //CurrentUser.sharedInstance = CurrentUser()
//            AllPublicPosts.dispose()
//            completion()
//        }catch{
//
//        }
//    }
    
    
    
    
    
}
