//
//  PostService.swift
//  Eventful
//
//  Created by Shawn Miller on 8/20/17.
//  Copyright © 2017 Make School. All rights reserved.
//

import Foundation
import  UIKit
import Firebase


struct PostService {
    
    static func create(for event: String?,for vidURL: String) {
        // 1
        guard let key = event else {
            return 
        }
        let storyUrl = vidURL
        // 2
        guard let uid = Auth.auth().currentUser?.uid else{
            return
        }
        
        let story = Story(url: storyUrl)
        
        let dict = story.dictValue
        
       let postRef = Database.database().reference().child("Stories").child(key).childByAutoId()
       
        let userRef = Database.database().reference().child("users").child(uid).child("Stories").child(key).childByAutoId()
        
        postRef.updateChildValues(dict)
        userRef.updateChildValues(dict)
    
        
        
    }
    
    
    static func showEvent(location:String, completion: @escaping ([Event]) -> Void) {
        //getting firebase root directory
        var currentEvents = [Event]()
        let eventsByLocationRef = Database.database().reference().child("eventsbylocation").child(location)
        
        let ref = Database.database().reference().child("events")
        let query = eventsByLocationRef.queryOrderedByKey()
        query.observeSingleEvent(of: .value, with: { (snapshot) in
            print(snapshot.value)
            
            guard let allObjects = snapshot.children.allObjects as? [DataSnapshot] else{
                return
            }
            guard let eventDictionary = snapshot.value as? [String:Any] else{
                return
            }
            
            eventDictionary.forEach({ (key,value) in
                print(key)
                print(value)
                EventService.show(forEventKey: value as! String, completion: { (event) in
                    currentEvents.append(.init(currentEventKey: value as! String, dictionary: (event?.eventDictionary)!))
                    completion(currentEvents)
                })

            })
        
            
            
//            
//            let events: [Event] = allObjects.flatMap{
//                guard let event = Event(snapshot: $0) else{
//                    return nil
//                }
//                return event
//            }
            
            //            guard let event = Event(snapshot: snapshot) else {
            //                return completion(nil)
            //                
            //            }
            
        })
    }
    
    

}
