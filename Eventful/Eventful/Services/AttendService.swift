//
//  AttendService.swift
//  Eventful
//
//  Created by Shawn Miller on 8/13/17.
//  Copyright © 2017 Make School. All rights reserved.
//

import Foundation
import FirebaseDatabase
import Firebase
import FirebaseAuth

struct AttendService {
    static func create(for event: String?, success: @escaping (Bool) -> Void) {
        // 1
        guard let key = event else {
            return success(false)
        }
        
        
        // 2
        
        guard let uid = Auth.auth().currentUser?.uid else{
            return
        }
        
        
        let attendData = ["Attending/\(key)/\(uid)" : true,
                          "users/\(uid)/\("Attending")/\(key)" : true]
        
       // let ref = Database.database().reference().child("users").child(uid).child("Attending")
        
        
        Database.database().reference().updateChildValues(attendData) { (err, _) in
            if let err = err{
                print("Failed to like post", err)
                return success(false)
            }
            print("Successfully liked post")
            return success(true)
        }
        
        let attendCountRef = Database.database().reference().child("events").child(key).child("attend:count")
        attendCountRef.runTransactionBlock({ (mutableData) -> TransactionResult in
            let currentCount = mutableData.value as? Int ?? 0
            
            mutableData.value = currentCount + 1
            
            return TransactionResult.success(withValue: mutableData)
        }, andCompletionBlock: { (error, _, _) in
            if let error = error {
                assertionFailure(error.localizedDescription)
                success(false)
            } else {
                success(true)
            }
        })
    }
    
    // 3 code to like a post
    
    
    static func fethAttendCount(for event: String?) -> Int {
        print("Fetching Attend Count")
        var numberAttending: Int = 0
        let attendRef = Database.database().reference().child("Attending").child(event!)
        attendRef.observe(.value, with: { (snapshot) in
            guard let attendCountDictionary = snapshot.value as? [String: Any] else{
                return
            }
            print(snapshot.value)
            
            numberAttending = attendCountDictionary.count
            print(numberAttending)
        }) { (err) in
            print("Failed to fetch attend count")
        }
        
        return numberAttending
        
    }
    
    
    
    
    
    
    static func delete(for event: String?, success: @escaping (Bool) -> Void) {
        guard let key = event else {
            return success(false)
        }
        
        guard let uid = Auth.auth().currentUser?.uid else{
            return
        }
        
        let attendData = ["Attending/\(key)/\(uid)" : NSNull(),
                          "users/\(uid)/\("Attending")/\(key)" : NSNull()]
        

        
          Database.database().reference().updateChildValues(attendData){ (error, _) in
            if let error = error {
                assertionFailure(error.localizedDescription)
                return success(false)
            }
            
            return success(true)
        }
    }
    
    
    
    
    
    static func setIsAttending(_ isLiked: Bool, for event: String?, success: @escaping (Bool) -> Void) {
        if isLiked {
            create(for: event, success: success)
        } else {
            delete(for: event, success: success)
        }
    }
    
    
    static func isEventAttended(_ event: String?, byCurrentUserWithCompletion completion: @escaping (Bool) -> Void) {
        guard let event = event else {
            assertionFailure("Error: event must have key.")
            return completion(false)
        }
        
        let attendRef = Database.database().reference().child("Attending").child(event)
        attendRef.queryEqual(toValue: nil, childKey: User.current.uid).observeSingleEvent(of: .value, with: { (snapshot) in
            if let _ = snapshot.value as? [String : Bool] {
                completion(true)
            } else {
                completion(false)
            }
        })
    }
    
}
