//
//  LoginViewController.swift
//  HackSC Project
//
//  Created by Adithya Nair on 2/1/20.
//  Copyright © 2020 Adithya Nair. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordView: UIView!
    @IBOutlet weak var loginButton: UIButton!
    
    var account: Account?
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        navigationController?.isNavigationBarHidden = false
        
        emailView.layer.cornerRadius = emailView.frame.height/4
        emailTextField.layer.cornerRadius = emailTextField.frame.height/4
        
        passwordView.layer.cornerRadius = passwordView.frame.height/4
        passwordTextField.layer.cornerRadius = passwordTextField.frame.height/4
        
        loginButton.layer.cornerRadius = loginButton.frame.height/4
        
    }
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        
        if let email = emailTextField.text, let password = passwordTextField.text {
        
            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                
                if let e = error {
                    
                    let alert = UIAlertController(title: "An error occured!", message: e.localizedDescription, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Got it!", style: .default, handler: nil))
                    
                    self.present(alert, animated: true)
                    
                } else {
                    
                    self.account!.setEmail(email)
                    
                    let docRef = self.db.collection(self.account!.getType()).document(self.account!.getUsername())
                    
                    docRef.getDocument { (document, error) in
                        if let document = document, document.exists {
                            let dataDescription = document.data()
                            self.account!.setDisplayName(dataDescription!["display_name"] as! String)
                            if self.account!.getType() == "User" {
                                self.performSegue(withIdentifier: "loginToPosts", sender: self)
                            } else {
                                self.performSegue(withIdentifier: "loginToTherapistMain", sender: self)
                            }
                            
                        } else {
                            print("Document does not exist")
                        }
                    }
                    
                }
                
            }
            
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "loginToPosts" {
            
            let destinationVC = segue.destination as! PostsViewController
            destinationVC.account = account
            
        } else if segue.identifier == "loginToTherapistMain" {
            
            let destinationVC = segue.destination as! TherapistMainViewController
            destinationVC.account = account
            
        }
        
    }
    
}
