//
//  GB3Data.swift
//  GB3HealthClubs
//
//  Created by Adrian Lopez on 12/13/17.
//  Copyright © 2017 Adrian Lopez. All rights reserved.
//

import Foundation
import UIKit

class GB3Data {
    var name: String
    var hours: String
    var imageName: UIImage
    
    init(name: String, hours: String) {
        self.name = name
        self.hours = hours
        
        imageName = UIImage(named: self.name)!
    }
}

