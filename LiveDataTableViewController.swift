//
//  LiveDataTableViewController.swift
//  GB3HealthClubs
//
//  Created by Adrian Lopez on 1/31/18.
//  Copyright © 2018 Adrian Lopez. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class LiveDataTableViewController: UITableViewController {

    var user: UserStruct!
    // MARK : Add users online
    let clovisRef = Database.database().reference(withPath: "Clovis")
    let northRef = Database.database().reference(withPath: "North")
    let palmRef = Database.database().reference(withPath: "Palm")
    let sunnysideRef = Database.database().reference(withPath: "Sunnyside")
    let westRef = Database.database().reference(withPath: "West")
    
    // MARK : Labels
    @IBOutlet weak var clovisLiveCountLabel: UILabel!
    @IBOutlet weak var northLiveCountLabel: UILabel!
    @IBOutlet weak var palmLiveCountLabel: UILabel!
    @IBOutlet weak var sunnysideLiveCountLabel: UILabel!
    @IBOutlet weak var westLiveCountLabel: UILabel!
    
    // MARK : Images
    @IBOutlet weak var clovisImage: UIImageView!
    @IBOutlet weak var northImage: UIImageView!
    @IBOutlet weak var palmImage: UIImageView!
    @IBOutlet weak var sunnysideImage: UIImageView!
    @IBOutlet weak var westImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Auth.auth().addStateDidChangeListener { auth, user in
            guard let user = user else { return }
            self.user = UserStruct(authData: user)
        }
        displayLiveCount()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 5
    }
    func clovisMembers() {
        clovisRef.observe(.value, with: { snapshot in
            if snapshot.exists() {
                let x = snapshot.childrenCount.description
                let myInt = Int(x)
                let calibratedVal = (myInt! - 1)
                
                print("Data Live Count: \(calibratedVal)")
                
                if calibratedVal <= 5 {
                    self.clovisImage.image = UIImage(named: "GreenButton")
                } else {
                    self.clovisImage.image = UIImage(named: "RedButton")
                }
                self.clovisLiveCountLabel.text = "\(calibratedVal)"
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
                let calibratedVal = (myInt! - 1)
                
                print("Data Live Count: \(calibratedVal)")
                if calibratedVal <= 5 {
                    self.northImage.image = UIImage(named: "GreenButton")
                } else {
                    self.northImage.image = UIImage(named: "RedButton")
                }
                self.northLiveCountLabel.text = "\(calibratedVal)"
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
                let calibratedVal = (myInt! - 1)
                
                print("Data Live Count: \(calibratedVal)")
                //self.palmLiveCountLabel.text = "\(calibratedVal)"
                if calibratedVal <= 5 {
                    self.palmImage.image = UIImage(named: "GreenButton")
                } else {
                    self.palmImage.image = UIImage(named: "RedButton")
                }
                self.palmLiveCountLabel.text = "\(calibratedVal)"
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
                let calibratedVal = (myInt! - 1)
                
                print("Data Live Count: \(calibratedVal)")
                if calibratedVal <= 0 {
                    self.sunnysideImage.image = UIImage(named: "GreenButton")
                } else {
                    self.sunnysideImage.image = UIImage(named: "RedButton")
                }
                self.sunnysideLiveCountLabel.text = "\(calibratedVal)"
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
                let calibratedVal = (myInt! - 1)
                
                print("Data Live Count: \(calibratedVal)")
                if calibratedVal <= 0 {
                    self.westImage.image = UIImage(named: "GreenButton")
                } else {
                    self.westImage.image = UIImage(named: "RedButton")
                }
                self.westLiveCountLabel.text = "\(calibratedVal)"
            } else {
                print("None==============")
            }
        })
    }
    
    func displayLiveCount() {
        print("********* Live Data VC *********")
        clovisMembers()
        northMembers()
        palmMembers()
        sunnysideMembers()
        westMembers()
    }
    
    // Mark : Notes
    /*
        I created this file and created cells in storyboard, need to retrieve data to be displayed.
    */
    
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
