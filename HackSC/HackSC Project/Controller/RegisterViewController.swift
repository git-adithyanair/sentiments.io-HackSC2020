//
//  RegisterViewController.swift
//  HackSC Project
//
//  Created by Adithya Nair on 2/1/20.
//  Copyright © 2020 Adithya Nair. All rights reserved.
//

import UIKit
import Firebase

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordView: UIView!
    @IBOutlet weak var registerButton: UIButton!
    
    var account: Account?
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        // super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        navigationController?.isNavigationBarHidden = false
        
        emailView.layer.cornerRadius = emailView.frame.height/4
        emailTextField.layer.cornerRadius = emailTextField.frame.height/4
        
        passwordView.layer.cornerRadius = passwordView.frame.height/4
        passwordTextField.layer.cornerRadius = passwordTextField.frame.height/4
        
        registerButton.layer.cornerRadius = registerButton.frame.height/4
        
    }
    
    @IBAction func registerButtonPressed(_ sender: UIButton) {
        
        if let email = emailTextField.text, let password = passwordTextField.text {
                
                Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                    
                    if let e = error {
                        
                        let alert = UIAlertController(title: "An error occured!", message: e.localizedDescription, preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Got it!", style: .default, handler: nil))
                        
                        self.present(alert, animated: true)
                        
                    } else {
                        
                        self.account!.setEmail(email)
                        
                        self.db.collection(self.account!.type).document(self.account!.username).setData([
                            "email": email,
                            "display_name": "",
                            "username": self.account!.username
                        ]) { err in
                            if let err = err {
                                print("Error writing document: \(err)")
                            } else {
                                print("Document successfully written!")
                            }
                        }
                        
                        self.performSegue(withIdentifier: "registerToDisplayName", sender: self)
                        
                    }
                    
                }
                
            }
            
        }
        
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            
            if segue.identifier == "registerToDisplayName" {
                
                let destinationVC = segue.destination as! DisplayNameController
                destinationVC.account = account
                
            }
        }
    
}
