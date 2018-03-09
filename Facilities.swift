//
//  Facilities.swift
//  GB3HealthClubs
//
//  Created by Adrian Lopez on 10/18/17.
//  Copyright © 2017 Adrian Lopez. All rights reserved.
//

import Foundation
import MapKit
import Contacts

class Facilities: NSObject, MKAnnotation {
    let title: String?
    let locationHours: String
    let coordinate: CLLocationCoordinate2D
    
    init(title: String, locationHours: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.locationHours = locationHours
        self.coordinate = coordinate
        super.init()
    }
    
    init?(json: [Any]) {
        // 1
        if let title = json[1] as? String {
            self.title = title
        } else {
            self.title = "No Title"
        }
        self.locationHours = json[2] as! String
        // 2
        if let latitude = Double(json[3] as! String),
            let longitude = Double(json[4] as! String) {
            self.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        } else {
            self.coordinate = CLLocationCoordinate2D()
        }
    }
    var subtitle: String? {
        return locationHours
    }
    
    var imageName: String? {
        return "Flag" // GB3 = Flag
    }
    
    // Annotation right callout accessory opens this mapItem in Maps app
    func mapItem() -> MKMapItem {
        let addressDict = [CNPostalAddressStreetKey: subtitle!]
        let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: addressDict)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = title
        return mapItem
    }
}
