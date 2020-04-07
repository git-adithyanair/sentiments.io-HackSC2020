//
//  DisplayNameController.swift
//  HackSC Project
//
//  Created by Adithya Nair on 2/1/20.
//  Copyright © 2020 Adithya Nair. All rights reserved.
//

import UIKit
import Firebase

class DisplayNameController: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var nameView: UIView!
    @IBOutlet weak var finishButton: UIButton!
    
    var account: Account?
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        navigationController?.isNavigationBarHidden = true
        
        nameView.layer.cornerRadius = nameView.frame.height/4
        nameTextField.layer.cornerRadius = nameTextField.frame.height/4
        
        finishButton.layer.cornerRadius = finishButton.frame.height/4
        
    }
    
    @IBAction func finishButtonPressed(_ sender: UIButton) {
        
        if nameTextField.text != "" {
            
            account?.setDisplayName(nameTextField.text!)
            
            db.collection(account!.getType()).document(account!.username).updateData([
            
                "display_name": account!.getDisplayName()
            
            ]) { err in
                if let err = err {
                    print("Error updating document: \(err)")
                } else {
                    print("Document successfully updated")
                }
            }
            
            if account!.getType() == "User" {
                performSegue(withIdentifier: "displayNameToPosts", sender: self)
            } else {
                performSegue(withIdentifier: "displayNameToTherapistMain", sender: self)
            }
            
        } else {
            
            let alert = UIAlertController(title: "Enter a display name!", message: "You need to enter a display name to continue.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Got it!", style: .default, handler: nil))
            
            self.present(alert, animated: true)
            
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "displayNameToPosts" {
            
            let destinationVC = segue.destination as! PostsViewController
            destinationVC.account = account
            
        } else if segue.identifier == "displayNameToTherapistMain" {
            
            let destinationVC = segue.destination as! TherapistMainViewController
            destinationVC.account = account
            
        }
        
    }
    
}
