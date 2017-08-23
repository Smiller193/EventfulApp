//
//  Event.swift
//  Eventful
//
//  Created by Shawn Miller on 8/12/17.
//  Copyright © 2017 Make School. All rights reserved.
//

import Foundation
import FirebaseDatabase.FIRDataSnapshot


struct  Event {
    let currentEventKey: String
    let currentEventName: String
    let currentEventImage: String
    let currentEventPromo: String?
    let currentEventDescription: String
    //nested properties
    let currentEventStreetAddress: String
    let currentEventCity: String
    let currentEventState: String
    let currentEventZip: Int
    //nested properties stop
    var currentAttendCount: Int
    var eventDictionary: [String: Any]{
        
        let locationDict = ["event:street:address": currentEventStreetAddress,"event:zip": currentEventZip,
                            "event:state": currentEventState, "event:city": currentEventCity] as [String : Any]
        
        return ["event:name":currentEventName,"event:imageURL" : currentEventImage,
        "event:description": currentEventDescription, "attend:count": currentAttendCount,
        "event:location": locationDict, "event:promo": currentEventPromo ?? ""]
    }
    
    init(currentEventKey: String, dictionary: [String:Any]) {
        self.currentEventKey = currentEventKey
        self.currentEventName = dictionary["event:name"] as? String ?? ""
        self.currentEventImage = dictionary["event:imageURL"] as? String ?? ""
        self.currentEventDescription = dictionary["event:description"] as? String ?? ""
        self.currentEventPromo = dictionary["event:promo"] as? String ?? ""
        self.currentAttendCount = dictionary["attend:count"] as? Int ?? 0
//nested properties
        let location = dictionary["event:location"] as?  [String:Any]
        self.currentEventStreetAddress = location?["event:street:address"] as? String ?? ""
        self.currentEventCity = location?["event:city"] as? String ?? ""
        self.currentEventState = location?["event:state"] as? String ?? ""
        self.currentEventZip = location?["event:zip"] as? Int ?? 0
    }
    
    init?(snapshot: DataSnapshot) {
        guard let dict = snapshot.value as? [String : Any],
            let currentEventName = dict["event:name"] as? String,
            let currentEventImage = dict["event:imageURL"] as? String,
            let currentEventDescription = dict["event:description"] as? String,
            let currentEventPromo = dict["event:promo"] as? String,
            let location = dict["event:location"] as?  [String:Any] ,
            let currentEventStreetAddress = location["event:street:address"] as? String,
         let currentEventCity = location["event:city"] as? String,
         let currentEventState = location["event:state"] as? String,
         let currentEventZip = location["event:zip"] as? Int,
         let currentAttendCount = dict["attend:count"] as? Int
            else { return nil }
        self.currentEventKey = snapshot.key
        self.currentEventName = currentEventName
        self.currentEventImage = currentEventImage
        self.currentEventDescription = currentEventDescription
        self.currentEventStreetAddress = currentEventStreetAddress
        self.currentEventCity = currentEventCity
        self.currentEventState = currentEventState
        self.currentEventZip = currentEventZip
        self.currentAttendCount = currentAttendCount
        self.currentEventPromo = currentEventPromo

    }
    
    
    
}
