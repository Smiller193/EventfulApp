//
//  EventService.swift
//  Eventful
//
//  Created by Shawn Miller on 8/16/17.
//  Copyright © 2017 Make School. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth


struct EventService {
    
    static func show(forEventKey eventKey: String, completion: @escaping (Event?) -> Void) {
        let ref = Database.database().reference().child("events").child(eventKey)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
           print(snapshot.value ?? "")
            guard let event = Event(snapshot: snapshot) else {
                return completion(nil)
            }
            completion(event)
        })
    }
}
