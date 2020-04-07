//
//  TherapistMainViewController.swift
//  HackSC Project
//
//  Created by Adithya Nair on 2/1/20.
//  Copyright © 2020 Adithya Nair. All rights reserved.
//

import UIKit
import Firebase

class TherapistMainViewController: UIViewController {
    
    @IBOutlet weak var usernameView: UIView!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    
    
    let db = Firestore.firestore()
    let sentimentClassifier = TextSentimentAnalysisv2()
    
    var account: Account?
    var tempArray: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        usernameView.layer.cornerRadius = usernameView.frame.height/4
        usernameTextField.layer.cornerRadius = usernameTextField.frame.height/4
        
        searchButton.layer.cornerRadius = searchButton.frame.height/4
        
        navigationController?.isNavigationBarHidden = false
        navigationItem.hidesBackButton = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Log Out", style: .plain, target: self, action: #selector(logoutPressed))
                
    }
    
    @objc func logoutPressed() {
        
        let firebaseAuth = Auth.auth()
        
        do {
            
            try firebaseAuth.signOut()
            navigationController?.popToRootViewController(animated: true)
            
        } catch let signOutError as NSError {
            
          print ("Error signing out: %@", signOutError)
            
        }
        
    }
    
    @IBAction func searchPressed(_ sender: UIButton) {
        
        db.collection("User").getDocuments() { (querySnapshot, err) in
        if let err = err {
            print("Error getting documents: \(err)")
        } else {
            for document in querySnapshot!.documents {
                self.tempArray.append(document.documentID)
            }
            if !self.tempArray.contains(self.usernameTextField.text!) {
                let alert = UIAlertController(title: "An error occured!", message: "That username was not found in our database.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Got it!", style: .default, handler: nil))
                            
                self.present(alert, animated: true)
                
            } else {
                postsOutputSentiment = []
                
                let docRef = self.db.collection("User").document(self.usernameTextField.text!).collection("Posts").order(by: "time")
                
                docRef.getDocuments() { (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
                        for document in querySnapshot!.documents {
                            var string = ""
                            var tempArray = [String]()
                            for char in document.data()["body"] as! String {
                                if (char != "." && char != "?" && char != "!") {
                                    string = string + String(char)
                                } else {
                                    let prediction = try! self.sentimentClassifier.prediction(text: string)
                                    tempArray.append(prediction.label)
                                    string = ""
                                    }
                                }
                                postsOutputSentiment.append(tempArray)
                            }
                        
                        }
                        self.performSegue(withIdentifier: "therapistMainToCharts", sender: self)
                        return
                    }

                }
            
            }
        
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ChartsViewController
        destinationVC.account = account
    }

}
