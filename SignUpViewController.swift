//
//  SignUpViewController.swift
//  GB3HealthClubs
//
//  Created by Adrian Lopez on 1/22/18.
//  Copyright © 2018 Adrian Lopez. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class SignUpViewController: UIViewController {

    // MARK : Constants
    let registeredSuccessfully = "registeredSuccessfully"
    let loginPage = "returnToLoginPage"
    
    // MARK : Firebase
    let ref = Database.database().reference(withPath: "gb3-members")
    var user: UserStruct!
    
    @IBOutlet weak var emailField: NSLayoutConstraint!
    // MARK : Outlets
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var membershipTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.hideKeyboardWhenTappedAround()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    @IBAction func finishedRegistering(_ sender: UIButton) {
        self.saveData()
        Auth.auth().createUser(withEmail: emailTextField.text!,
                               password: passwordTextField.text!) { user, error in
                                if error == nil {
                                    Auth.auth().signIn(withEmail: self.emailTextField.text!,
                                                       password: self.passwordTextField.text!)
                                }
        }
        self.performSegue(withIdentifier: self.registeredSuccessfully, sender: nil)
    }
    
    @IBAction func returnToLogin(_ sender: UIButton) {
        self.performSegue(withIdentifier: self.loginPage, sender: nil)
    }
    
    func saveData() {
        let myVC = storyboard?.instantiateViewController(withIdentifier: "SecondVC") as! MemberViewController
        let membershipText = membershipTextField.text
        let memberName = nameTextField.text
        UserDefaults.standard.set(memberName, forKey: "Key") //setObject
        UserDefaults.standard.set(membershipText, forKey: "membershipKey") //setObject
        myVC.namePassed = memberName
        myVC.membershipPassed = membershipText
    }
}
// Put this piece of code anywhere you like
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        
    }
}
