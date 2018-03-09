//
//  User.swift
//  GB3HealthClubs
//
//  Created by Adrian Lopez on 1/22/18.
//  Copyright © 2018 Adrian Lopez. All rights reserved.
//

import Foundation
import FirebaseAuth

struct UserStruct {
    
    let uid: String
    let email: String
    
    init(authData: User) {
        uid = authData.uid
        email = authData.email!
        
    }
    
    init(uid: String, email: String) {
        self.uid = uid
        self.email = email
    }
}
