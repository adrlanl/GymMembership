//
//  FirstViewController.swift
//  GB3HealthClubs
//
//  Created by Adrian Lopez on 10/18/17.
//  Copyright © 2017 Adrian Lopez. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import CoreImage
import CoreLocation

class MemberViewController: UIViewController {
    
    // MARK : Firebase
    let ref = Database.database().reference(withPath: "gb3-members")
    var user: UserStruct!
    
    // MARK : Add users online
    let clovisRef = Database.database().reference(withPath: "Clovis")
    let northRef = Database.database().reference(withPath: "North")
    let palmRef = Database.database().reference(withPath: "Palm")
    let sunnysideRef = Database.database().reference(withPath: "Sunnyside")
    let westRef = Database.database().reference(withPath: "West")
    let locationManager = CLLocationManager()
    
    // MARK : Outlets
    @IBOutlet weak var displayNameLabel: UILabel!
    @IBOutlet weak var displayMembershipLabel: UILabel!
    @IBOutlet weak var displayBarcode: UIImageView!
    
    @IBOutlet weak var welcomeLabel: UILabel!
    // MARK : Variables
    var namePassed: String! = UserDefaults.standard.string(forKey: "Key")
    var membershipPassed: String! = UserDefaults.standard.string(forKey: "membershipKey")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //self.view.backgroundColor = UIColor(red:0.09, green:0.11, blue:0.13, alpha:1.0)
        self.view.backgroundColor = UIColor(red:0.00, green:0.00, blue:0.00, alpha:1.0)
        // Location
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        
        Auth.auth().addStateDidChangeListener { auth, user in
            guard let user = user else { return }
            self.user = UserStruct(authData: user)
            // Get UID for user
            let uniqueID = self.user.uid
            UserDefaults.standard.set(uniqueID, forKey: "UDID")
            //self.addToFirebase()
            self.ifNoValue()
        }
        setLocations()
        displayLiveCount()
    }

    override func viewDidAppear(_ animated: Bool) {
         //self.addToFirebase()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func ifNoValue() {
        let userNotFound = self.user?.uid // try memberItem if crashes still
        if userNotFound != nil {
            print("User found, profile retrieved: \(userNotFound!)")
            //addToDatabase(uniqueID: userNotFound!)
            retrieveData()
        } else {
            print("Added to database")
            // addToFirebase()
        }
    }
    
    func addToDatabase(uniqueID: String!) -> String {
        let uidd = uniqueID!
        membershipPassed = UserDefaults.standard.string(forKey: "membershipKey")
        let memberItem = MemberData(membership: membershipPassed,
                                    addedByUser: self.user.email,
                                    memberName: namePassed)
        let memberItemRef = self.ref.child(uidd)
        memberItemRef.setValue(memberItem.toAnyObject())
        return uidd
    }
    
    func retrieveData() {
        let userDat = UserDefaults.standard.string(forKey: "UDID")!
        let urlString = "https://gb3clubmembers.firebaseio.com/gb3-members/\(userDat).json"
        
        let url = URL(string: urlString)
        URLSession.shared.dataTask(with:url!) { (data, response, error) in
            if error != nil {
                print("Error #1: \(error!)")
            } else {
                do {
                    
                    let parsedData = try JSONSerialization.jsonObject(with: data!) as! [String:String]
                    let memNum = parsedData["membership"] as! String
                    let memName = parsedData["memberName"] as! String
                    
                    print("Hello " + memName)
                    print("Member: " + memNum)
                    let sharedDefaults = UserDefaults(suiteName: "group.gb3healthclubs")
                    sharedDefaults?.setValue(memNum, forKey: "extensionMembership")
                    
                    DispatchQueue.main.async {
                        self.displayNameLabel.text = "Name: \(memName)"
                        self.displayMembershipLabel.text = memNum
                        let image = self.generateBarcode(from: "\(memNum)")
                        self.displayBarcode.image = image
                    }
                } catch let error as NSError {
                    let uniqueID = self.user.uid
                    print("Error #2: \(error)")
                    self.addToDatabase(uniqueID: uniqueID)
                }
            }
            
            }.resume()
    }
    
    func generateBarcode(from string: String) -> UIImage? {
        let data = string.data(using: String.Encoding.ascii)
        
        if let filter = CIFilter(name: "CIPDF417BarcodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 3, y: 3)
            
            if let output = filter.outputImage?.transformed(by: transform) {
                return UIImage(ciImage: output)
            }
        }
        
        return nil
    }
    
    // Apple Wallet
    @IBAction func addToAW(_ sender: UIButton) {
        let urlString = "https://gb3clubs.herokuapp.com"
        if let url = URL(string: urlString)
        {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    func setLocations() {
        print("Added geofences")
        // Your coordinates go here (lat, lon)
        let clovis = CLLocationCoordinate2DMake(36.838870, -119.680584)
        let north = CLLocationCoordinate2DMake(36.869661, -119.756545)
        let palm = CLLocationCoordinate2DMake(36.850968, -119.807620)
        let sunnyside = CLLocationCoordinate2DMake(36.736095, -119.679523)
        let west = CLLocationCoordinate2DMake(36.836452, -119.8820922)
        
        /* Create a region centered on desired location,
         choose a radius for the region (in meters)
         choose a unique identifier for that region */
        let clovisRegion = CLCircularRegion(center: clovis, radius: 100.00, identifier: "Clovis")
        let northRegion = CLCircularRegion(center: north, radius: 100.00, identifier: "North")
        let palmRegion = CLCircularRegion(center: palm, radius: 100.00, identifier: "Palm")
        let sunnysideRegion = CLCircularRegion(center: sunnyside, radius: 100.00, identifier: "Sunnyside")
        let westRegion = CLCircularRegion(center: west, radius: 100.00, identifier: "West")
        
        clovisRegion.notifyOnEntry = true
        clovisRegion.notifyOnExit = true
        
        northRegion.notifyOnEntry = true
        northRegion.notifyOnExit = true
        
        palmRegion.notifyOnEntry = true
        palmRegion.notifyOnExit = true
        
        sunnysideRegion.notifyOnEntry = true
        sunnysideRegion.notifyOnExit = true
        
        westRegion.notifyOnEntry = true
        westRegion.notifyOnExit = true
        
        locationManager.startMonitoring(for: clovisRegion)
        locationManager.startMonitoring(for: northRegion)
        locationManager.startMonitoring(for: palmRegion)
        locationManager.startMonitoring(for: sunnysideRegion)
        locationManager.startMonitoring(for: westRegion)
    }
    
    func clovisMembers() {
        clovisRef.observe(.value, with: { snapshot in
            if snapshot.exists() {
                let x = snapshot.childrenCount.description
                let myInt = Int(x)
                
                print("Clovis Live Count: \(myInt! - 1)")
            } else {
                print("None==============")
            }
        })
    }
    
    func northMembers() {
        northRef.observe(.value, with: { snapshot in
            if snapshot.exists() {
                let x = snapshot.childrenCount.description
                let myInt = Int(x)
                
                print("North Live Count: \(myInt! - 1)")
            } else {
                print("None==============")
            }
        })
    }
    
    func palmMembers() {
        palmRef.observe(.value, with: { snapshot in
            if snapshot.exists() {
                let x = snapshot.childrenCount.description
                let myInt = Int(x)
                
                print("Palm Live Count: \(myInt! - 1)")
            } else {
                print("None==============")
            }
        })
    }
    
    func sunnysideMembers() {
        sunnysideRef.observe(.value, with: { snapshot in
            if snapshot.exists() {
                let x = snapshot.childrenCount.description
                let myInt = Int(x)
                
                print("Sunnyside Live Count: \(myInt! - 1)")
            } else {
                print("None==============")
            }
        })
    }
    
    func westMembers() {
        westRef.observe(.value, with: { snapshot in
            if snapshot.exists() {
                let x = snapshot.childrenCount.description
                let myInt = Int(x)
                
                print("West Live Count: \(myInt! - 1)")
            } else {
                print("None==============")
            }
        })
    }
    
    func displayLiveCount() {
        print("********* Live Data *********")
        clovisMembers()
        northMembers()
        palmMembers()
        sunnysideMembers()
        westMembers()
    }
    
    func locationAccessDenied(){
        let alertController = UIAlertController(title: "Allow GB3 access to your location",
                                                message: "GB3 uses your location to update live user traffic to improve the member experience.",
                                                preferredStyle: .alert)
        
        let settingsAction = UIAlertAction(title: "Settings", style: .default) { (alertAction) in
            
            // THIS IS WHERE THE MAGIC HAPPENS!!!!
            if let appSettings = NSURL(string: UIApplicationOpenSettingsURLString) {
                UIApplication.shared.open(appSettings as URL, options: [:], completionHandler: nil)
                //UIApplication.shared.openURL(appSettings as URL)
            }
        }
        alertController.addAction(settingsAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
}

extension MemberViewController: CLLocationManagerDelegate {
    // called when user Exits a monitored region
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        if region is CLCircularRegion {
            // Do what you want if this information
            // self.handleEvent(forRegion: region)
            print("Exited: \(region.identifier)")
    
            let someLocation: String = region.identifier
            switch someLocation {
            case "Clovis":
                print("Left GB3 Clovis")
                welcomeLabel.text = "Welcome to the GB3 App!"
                let currentUserRef = clovisRef.child(self.user.uid)
                currentUserRef.setValue("Online")
                currentUserRef.removeValue() // Remove user from live count if left location
            case "North":
                print("Left GB3 North")
                welcomeLabel.text = "Welcome to the GB3 App!"
                let currentUserRef = northRef.child(self.user.uid)
                currentUserRef.setValue("Online")
                currentUserRef.removeValue() // Remove user from live count if left location
            case "Palm":
                print("Left GB3 Palm")
                welcomeLabel.text = "Welcome to the GB3 App!"
                let currentUserRef = palmRef.child(self.user.uid)
                currentUserRef.setValue("Online")
                currentUserRef.removeValue() // Remove user from live count if left location
            case "Sunnyside":
                print("Left GB3 Sunnyside")
                welcomeLabel.text = "Welcome to the GB3 App!"
                let currentUserRef = sunnysideRef.child(self.user.uid)
                //currentUserRef.setValue("Online")
                currentUserRef.removeValue() // Remove user from live count if left location
            case "West":
                print("Left GB3 West")
                welcomeLabel.text = "Welcome to the GB3 App!"
                let currentUserRef = westRef.child(self.user.uid)
                currentUserRef.setValue("Online")
                currentUserRef.removeValue() // Remove user from live count if left location
            default:
                print("Left other location")
            }
        }
    }
    
    // called when user Enters a monitored region
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        if region is CLCircularRegion {
            // Do what you want if this information
            //self.handleEvent(forRegion: region)
            print("Entered: \(region.identifier)")
            
            let someLocation: String = region.identifier
            switch someLocation {
            case "Clovis":
                print("You're at GB3 Clovis")
                welcomeLabel.text = "Welcome to our Clovis location!"
                // 1
                let currentUserRef = clovisRef.child(self.user.uid)
                // 2
                currentUserRef.setValue("Online")
            case "North":
                print("You're at GB3 North")
                welcomeLabel.text = "Welcome to our North location!"
                // 1
                let currentUserRef = northRef.child(self.user.uid)
                // 2
                currentUserRef.setValue("Online")
            case "Palm":
                print("You're at GB3 Palm")
                welcomeLabel.text = "Welcome to our Palm location!"
                // 1
                let currentUserRef = palmRef.child(self.user.uid)
                // 2
                currentUserRef.setValue("Online")
            case "Sunnyside":
                print("You're at GB3 Sunnyside")
                welcomeLabel.text = "Welcome to our Sunnyside location!"
                // 1
                let currentUserRef = sunnysideRef.child(self.user.uid)
                // 2
                currentUserRef.setValue("Online")
            case "West":
                print("You're at GB3 West")
                welcomeLabel.text = "Welcome to our West location!"
                // 1
                let currentUserRef = westRef.child(self.user.uid)
                // 2
                currentUserRef.setValue("Online")
            default:
                print("Some other location")
            }
        }
    }
    
    func handleEvent(forRegion region: CLRegion!) {
        print("not in region!")
    }

    // Handle if user denied 'Always Allow'
    func startMonitoring(_ manager:CLLocationManager, region:CLCircularRegion) {
        if !CLLocationManager.isMonitoringAvailable(for: CLCircularRegion.self) {
            print("Cannot monitor location")
            //locationAccessDenied()
            return
        }
        if CLLocationManager.authorizationStatus() != .authorizedAlways {
            print("Please grant access")
            locationAccessDenied()
        } else {
            let locationManager = CLLocationManager()
            locationManager.startMonitoring(for: region)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, monitoringDidFailFor region: CLRegion?, withError error: Error) {
        print("This func called")
    }
}
