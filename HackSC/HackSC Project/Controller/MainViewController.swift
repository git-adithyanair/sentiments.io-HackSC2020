//
//  ViewController.swift
//  HackSC Project
//
//  Created by Adithya Nair on 2/1/20.
//  Copyright © 2020 Adithya Nair. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet weak var typeSelector: UISegmentedControl!
    
    
    var account = Account()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Do any additional setup after loading the view.
        
        navigationController?.isNavigationBarHidden = true
        
    }
    
    @IBAction func loginPressed(_ sender: UIButton) {
        
        switch typeSelector.selectedSegmentIndex {
        case 0:
            account.setType("User")
        default:
            account.setType("Therapist")
        }
        
        performSegue(withIdentifier: "mainToLogin", sender: self)
        
    }
    
    @IBAction func registerPressed(_ sender: UIButton) {
        
        switch typeSelector.selectedSegmentIndex {
        case 0:
            account.setType("User")
        default:
            account.setType("Therapist")
        }
        
        performSegue(withIdentifier: "mainToRegister", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "mainToLogin" {
            
            let destinationVC = segue.destination as! LoginViewController
            destinationVC.account = account
            
        } else if segue.identifier == "mainToRegister" {
            
            let destinationVC = segue.destination as! RegisterViewController
            destinationVC.account = account
            
        }
        
    }

}

