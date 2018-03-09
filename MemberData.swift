//
//  MemberData.swift
//  GB3HealthClubs
//
//  Created by Adrian Lopez on 1/22/18.
//  Copyright © 2018 Adrian Lopez. All rights reserved.
//

import Foundation
import FirebaseDatabase

struct MemberData {
    
    let key: String
    let membership: String
    let addedByUser: String
    let memberName: String
    let ref: DatabaseReference?
    
    init(membership: String, addedByUser: String, memberName: String, key: String = "") {
        self.key = key
        self.membership = membership
        self.addedByUser = addedByUser
        self.memberName = memberName
        self.ref = nil
    }
    
    init(snapshot: DataSnapshot) {
        key = snapshot.key
        let snapshotValue = snapshot.value as! [String: AnyObject]
        membership = snapshotValue["membership"] as! String
        addedByUser = snapshotValue["addedByUser"] as! String
        memberName = snapshotValue["memberName"] as! String
        ref = snapshot.ref
    }
    
    func toAnyObject() -> Any {
        return [
            "membership": membership,
            "addedByUser": addedByUser,
            "memberName": memberName
        ]
    }
}
