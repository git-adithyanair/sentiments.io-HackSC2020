//
//  PostsViewController.swift
//  HackSC Project
//
//  Created by Adithya Nair on 2/1/20.
//  Copyright © 2020 Adithya Nair. All rights reserved.
//

import UIKit
import Firebase

var postsOutputSentiment = [[String]]()

class PostsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var tableView: UITableView!
    
    let db = Firestore.firestore()
    let sentimentClassifier = TextSentimentAnalysisv2()
    
    var account: Account?
    var posts: [Post] = []
    var postToInfo: Post? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        navigationController?.isNavigationBarHidden = false
        navigationItem.hidesBackButton = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Log Out", style: .plain, target: self, action: #selector(logoutPressed))
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: .add, style: .plain, target: self, action: #selector(plusPressed)),
            UIBarButtonItem(image: UIImage(systemName: "chart.bar.fill"), style: .done, target: self, action: #selector(statsPressed))
        ]
        
        navigationItem.title = "\(account!.getDisplayName())'s Thoughts"
        
        tableView.dataSource = self
        tableView.delegate = self
        
        loadPosts()
        
    }
    
    func loadPosts() {
        
        db.collection("User").document(account!.getUsername()).collection("Posts").order(by: "time")
            .addSnapshotListener { (querySnapshot, error) in
            
            if let e = error {
                
                print(e)
                
            } else {
                
                if let snapshotDocuments = querySnapshot?.documents {
                    
                    self.posts = []
                    
                    for doc in snapshotDocuments {
                        
                        if let title = doc.data()["title"] as? String,
                            let body = doc.data()["body"] as? String {
                            
                            let post = Post(title: title, body: body)
                            self.posts.append(post)
                            
                            DispatchQueue.main.async {
                                
                                self.tableView.reloadData()
                                let indexPath = IndexPath(row: self.posts.count - 1, section: 0)
                                self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
                                
                            }
                            
                        }
                        
                    }
                    
                }
                
            }
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellReuseIdentifier", for: indexPath) as! CustomTableViewCell
            
        let post = posts[indexPath.row]
        
        cell.titleLabel.text = post.title
        cell.subtitleLabel.text = post.body
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        postToInfo = posts[indexPath.row]
        performSegue(withIdentifier: "postsToInfo", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "postsToInfo" {
            let destinationVC = segue.destination as! PostInfoViewController
            destinationVC.post = postToInfo
        } else if segue.identifier == "postsToNew" {
            let destinationVC = segue.destination as! NewPostViewController
            destinationVC.account = account
        }
        
    }
    
    @objc func statsPressed () {
        
        postsOutputSentiment = []
        
        let docRef = self.db.collection("User").document(self.account!.getUsername()).collection("Posts").order(by: "time")
        
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
        
        }
        
        performSegue(withIdentifier: "postsToCharts", sender: self)
        
    }
    
    @objc func plusPressed() {
        
        performSegue(withIdentifier: "postsToNew", sender: self)
        
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
    
}
