//
//  DetailsViewController.swift
//  GB3HealthClubs
//
//  Created by Adrian Lopez on 10/18/17.
//  Copyright © 2017 Adrian Lopez. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!

    var gb3Locations = [GB3Data]()
    
    // Firebase Data
    //let classesRef = Database.database().reference(withPath: "Classes")

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        getURLScheme()
        
        // Key received from Firebase
        let clovisURL = UserDefaults.standard.string(forKey: "clovisURLScheme")
        let northURL = UserDefaults.standard.string(forKey: "northURLScheme")
        let palmURL = UserDefaults.standard.string(forKey: "palmURLScheme")
        let sunURL = UserDefaults.standard.string(forKey: "sunnysideURLScheme")
        let westURL = UserDefaults.standard.string(forKey: "westURLScheme")
        
        // Static - Feb Class Keys - March Keys
        let temp1 = "b6e03a_0e54cbdb5ef748efb39cfa9fd191d39d" // Clovis  - b6e03a_b2cc8a35c1d74b818b1851d9a041b8e3
        let temp2 = "b6e03a_ab138b296186434c8b6df63a82392261" // North - b6e03a_f1fde31d07c54486957f24e37bb3da19
        let temp3 = "b6e03a_e327fa8eb9074fe4ad09a3506df02a58" // Palm - b6e03a_3954e4e2d259482d91ca046202de793f
        let temp4 = "b6e03a_5347f54c59fd40bfbbc89ee1815995c8" // Sunnyside - b6e03a_d3887878a3884416877023d14534bc7d
        let temp5 = "b6e03a_109a2a88ff32437aaa699c3427a78a06" // West - b6e03a_cdf24cd985d94a69b7db3a22839fe7b6
        
        let clo = GB3Data(name: "Clovis", hours: "\(clovisURL ?? temp1)")
        gb3Locations.append(clo)
        
        let champlain = GB3Data(name: "North", hours: "\(northURL ?? temp2)")
        gb3Locations.append(champlain)
        
        let palm = GB3Data(name: "Palm", hours: "\(palmURL ?? temp3)")
        gb3Locations.append(palm)
        
        let sunnyside = GB3Data(name: "Sunnyside", hours: "\(sunURL ?? temp4)")
        gb3Locations.append(sunnyside)
        
        let west = GB3Data(name: "West", hours: "\(westURL ?? temp5)")
        gb3Locations.append(west)
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func getURLScheme() {
        let urlString = "https://gb3clubmembers.firebaseio.com/Classes.json"
        let url = URL(string: urlString)
        URLSession.shared.dataTask(with:url!) { (data, response, error) in
            if error != nil {
                print("Error #1: \(error!)")
            } else {
                do {
                    // Retrieve key from Firebase
                    let parsedData = try JSONSerialization.jsonObject(with: data!) as! [String:String]
                    let clovisURLScheme = parsedData["Clovis"] as! String
                    let northURLScheme = parsedData["North"] as! String
                    let palmURLScheme = parsedData["Palm"] as! String
                    let sunnysideURLScheme = parsedData["Sunnyside"] as! String
                    let westURLScheme = parsedData["West"] as! String
                
                    let cloURLScheme = clovisURLScheme
                    UserDefaults.standard.set(cloURLScheme, forKey: "clovisURLScheme")
                    let norURLScheme = northURLScheme
                    UserDefaults.standard.set(norURLScheme, forKey: "northURLScheme")
                    let pamURLScheme = palmURLScheme
                    UserDefaults.standard.set(pamURLScheme, forKey: "palmURLScheme")
                    let sunURLScheme = sunnysideURLScheme
                    UserDefaults.standard.set(sunURLScheme, forKey: "sunnysideURLScheme")
                    let wesURLScheme = westURLScheme
                    UserDefaults.standard.set(wesURLScheme, forKey: "westURLScheme")
                    
                    print("Clovis: " + clovisURLScheme)
                    print("North: " + northURLScheme)
                    print("Palm: " + palmURLScheme)
                    print("Sunnyside: " + sunnysideURLScheme)
                    print("West: " + westURLScheme)
                    
                    DispatchQueue.main.async {
                        print("Store URL Schemes")
                    }
                } catch let error as NSError {
                    print("Error #2: \(error)")
                }
            }
            
            }.resume()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gb3Locations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "basicCell")
        cell?.textLabel?.text = gb3Locations[indexPath.row].name
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        _ = indexPath.row
        
        performSegue(withIdentifier: "showDetails", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? DataViewController {
            destination.gb3Loc = gb3Locations[(tableView.indexPathForSelectedRow?.row)!]
        }
    }
}
