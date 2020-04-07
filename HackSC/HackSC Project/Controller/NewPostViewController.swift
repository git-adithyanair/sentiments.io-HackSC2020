//
//  NewPostViewController.swift
//  HackSC Project
//
//  Created by Adithya Nair on 2/1/20.
//  Copyright © 2020 Adithya Nair. All rights reserved.
//

import UIKit
import Firebase

class NewPostViewController: UIViewController, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var bodyTextView: UITextView!
    
    let db = Firestore.firestore()
    let sentimentClassifier = TextSentimentAnalysisv2()
    let imagePicker = UIImagePickerController()
    var image = UIImage()
    var account: Account? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        navigationItem.rightBarButtonItems = [UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(cameraPressed)), UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donePressed))]
        
        imagePicker.delegate = self
        bodyTextView.delegate = self
        
        bodyTextView.text = "Body"
        bodyTextView.textColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        bodyTextView.font = UIFont(name: "HelveticaNeue", size: 20)
        
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1) {
            textView.text = ""
            textView.textColor = UIColor.systemTeal
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Body"
            textView.textColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        }
    }
    
    @objc func cameraPressed() {
        
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imagePicker.dismiss(animated: true, completion: nil)
        image = (info[.originalImage] as? UIImage)!
        let vision = Vision.vision()
        let textRecognizer = vision.cloudTextRecognizer()
        let vImage = VisionImage(image: image)
        textRecognizer.process(vImage) { result, error in
          guard error == nil, let result = result else {
            // ...
            return
          }

          // Recognized text
            self.bodyTextView.text = ""
            for block in result.blocks {
                for line in block.lines {
                    for element in line.elements {
                        let elementText = element.text
                        self.bodyTextView.text += "\(elementText) "
                    }
                }
            }
            
            self.bodyTextView.textColor = UIColor.systemTeal
        }

    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        imagePicker.dismiss(animated: true, completion: nil)
        
    }
    
    @objc func donePressed() {
        
    self.db.collection("User").document(self.account!.getUsername()).collection("Posts").addDocument(data: [
            "title": titleTextField.text!,
            "body": bodyTextView.text!,
            "time": Date().timeIntervalSince1970
        ]) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
                self.navigationController?.popViewController(animated: true)
                self.dismiss(animated: true, completion: nil)
            }
        }
        
    }
    
}
