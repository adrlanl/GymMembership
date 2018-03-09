//
//  SecondViewController.swift
//  GB3HealthClubs
//
//  Created by Adrian Lopez on 10/18/17.
//  Copyright © 2017 Adrian Lopez. All rights reserved.
//

import UIKit
import MapKit

class LocationsViewController: UIViewController {
    var loadFacilities: [Facilities] = []
    @IBOutlet weak var mapView: MKMapView!
    let regionRadius: CLLocationDistance = 24140.2
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let initialLocation = CLLocation(latitude: 36.7796082, longitude: -119.7779788)
        centerMapOnLocation(location: initialLocation)
        
        mapView.delegate = self
        mapView.register(FacilityView.self,
                         forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        loadInitialData()
        mapView.addAnnotations(loadFacilities)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  regionRadius, regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func loadInitialData() {
        // 1 - GB3 = ClubData
        guard let fileName = Bundle.main.path(forResource: "ClubData", ofType: "json")
            else { return }
        let optionalData = try? Data(contentsOf: URL(fileURLWithPath: fileName))
        
        guard
            let data = optionalData,
            // 2
            let json = try? JSONSerialization.jsonObject(with: data),
            // 3
            let dictionary = json as? [String: Any],
            // 4
            let works = dictionary["data"] as? [[Any]]
            else { return }
        // 5
        let validWorks = works.flatMap { Facilities(json: $0) }
        loadFacilities.append(contentsOf: validWorks)
    }
}
extension LocationsViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView,
                 calloutAccessoryControlTapped control: UIControl) {
        let location = view.annotation as! Facilities
        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
        location.mapItem().openInMaps(launchOptions: launchOptions)
    }
}
