//
//  UserService.swift
//  Eventful
//
//  Created by Shawn Miller on 7/26/17.
//  Copyright © 2017 Make School. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseStorage
import  UIKit



struct UserService {
    
    /// will create a user in the database
    static func create(_ firUser: FIRUser, username: String, gender: String,profilePic: String,bio: String,location: String, completion: @escaping (User?) -> Void) {
        let userAttrs = ["username": username,
                         "gender": gender,
                         "location": location,
                         "profilePic": profilePic,
                         "bio": bio] as [String : Any]
        //creats the path in the database where we want our user attributes to be created
        //Also sets the value at that point in the tree to the user Attributes array
        let ref = Database.database().reference().child("users").child(firUser.uid)
        ref.setValue(userAttrs) { (error, ref) in
            if let error = error {
                assertionFailure(error.localizedDescription)
                return completion(nil)
            }
            
            ref.observeSingleEvent(of: .value, with: { (snapshot) in
                let user = User(snapshot: snapshot)
                completion(user)
            })
        }
    }
    
    //Will allow you to edit user data in firebase
    
    static func edit(username: String, bio: String, completion: @escaping (User?) -> Void) {
        let userAttrs = ["username": username,
                         "bio": bio] as [String : Any]
        
        let ref = Database.database().reference().child("users").child(User.current.uid)
        ref.updateChildValues(userAttrs) { (error, ref) in
            if let error = error {
                assertionFailure(error.localizedDescription)
                return completion(nil)
            }
            ref.observeSingleEvent(of: .value, with: { (snapshot) in
                let user = User(snapshot: snapshot)
                completion(user)
            })
        }
    
    
    
    }
    
    // will strictly handle editing the user section in the database
    static func editProfileImage(url: String, completion: @escaping (User?) -> Void) {
        let userAttrs = ["profilePic": url]
        
        let ref = Database.database().reference().child("users").child(User.current.uid)
        ref.updateChildValues(userAttrs) { (error, ref) in
            if let error = error {
                assertionFailure(error.localizedDescription)
                return completion(nil)
            }
            
            ref.observeSingleEvent(of: .value, with: { (snapshot) in
                let user = User(snapshot: snapshot)
                completion(user)
            })
        }
    }
    
    
    
    // will observe the user object in the database for any changes and make sure that they are updated
    static func observeProfile(for uid: String, completion: @escaping (DatabaseReference, User?) -> Void) -> DatabaseHandle {
        let userRef = Database.database().reference().child("users").child(uid)
        return userRef.observe(.value, with: { snapshot in
            guard let user = User(snapshot: snapshot) else {
                return completion(userRef, nil)
            }
            completion(userRef, user)
        })
    }
    
    //shows the data at the user endpoint
    //observeSingleEvent(of:with:) will only trigger the event callback once. This is useful for reading data that only needs to be loaded once and isn't expected to change
    
    static func show(forUID uid: String, completion: @escaping (User?) -> Void) {
        let ref = Database.database().reference().child("users").child(uid)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let user = User(snapshot: snapshot) else {
                return completion(nil)
                
            }
            
            completion(user)
        })
    }
    
    
    
    
    static func usersExcludingCurrentUser(completion: @escaping ([User]) -> Void) {
        let currentUser = User.current
        // 1
        let ref = Database.database().reference().child("users")
        
        // 2
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let snapshot = snapshot.children.allObjects as? [DataSnapshot]
                else { return completion([]) }
            
            // 3
            let users =
                snapshot
                    .flatMap(User.init)
                    .filter { $0.uid != currentUser.uid }
            
            // 4
            let dispatchGroup = DispatchGroup()
            users.forEach { (user) in
                dispatchGroup.enter()
                
                // 5
                FollowService.isUserFollowed(user) { (isFollowed) in
                    user.isFollowed = isFollowed
                    dispatchGroup.leave()
                }
            }
            
            // 6
            dispatchGroup.notify(queue: .main, execute: {
                completion(users)
            })
        })
    }
    
}
