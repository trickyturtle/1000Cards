//
//  DeckInfoView.swift
//  1000 Cards
//
//  Created by David Alexander on 11/3/16.
//  Copyright © 2016 Isaac Garza. All rights reserved.
//

import Foundation
import UIKit

class DeckInfoView: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    var deck = PFObject(className: "Deck")
    var isPublic = false

    @IBOutlet weak var titleTF: UITextField!
    @IBOutlet weak var descriptionTF: UITextView!
    
    @IBAction func updateDeckInfo(_ sender: AnyObject) {
        //handle empty input
        if((titleTF.text?.isEmpty)!){
            let controller = UIAlertController(title: "Incomplete", message: "Please enter a title", preferredStyle: .alert)
            controller.addAction(UIAlertAction(title: "Okay",style: .cancel, handler: nil))
            self.present(controller, animated: true, completion: nil)
            print("no title for deck")
        }
        else{
            deck["title"] = titleTF.text!
            deck["description"] = descriptionTF.text!
            deck.saveInBackground()
            let controller = UIAlertController(title: "Success!", message: "Deck info saved", preferredStyle: .alert)
            controller.addAction(UIAlertAction(title: "Okay",style: .cancel, handler: nil))
            self.present(controller, animated: true, completion: nil)
            navigationItem.hidesBackButton = false
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        titleTF.text = deck["title"] as! String?
        descriptionTF.text = deck["description"] as! String!
        if ((titleTF.text?.isEmpty)!) {
            navigationItem.hidesBackButton = true
        }
        isPublic = deck["public"] as! Bool
        var message = ""
        if (!isPublic) {
            message = "Make Public"
        } else {
            message = "Make Private"
        }
        let publicButton = UIBarButtonItem(title: message, style: .plain, target: self, action: #selector(DeckInfoView.makePublicButton))
        self.navigationItem.rightBarButtonItem = publicButton
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func makePublicButton() {
        var message = ""
        if (!isPublic) {
            message = "Public"
        } else {
            message = "Private"
        }
        deck["public"] = !isPublic
        deck.saveInBackground(block: { succeed, error in
            if (succeed) {
                let controller = UIAlertController(title: "Success!", message: "Deck made \(message)", preferredStyle: .alert)
                controller.addAction(UIAlertAction(title: "Okay",style: .cancel, handler: nil))
                self.present(controller, animated: true, completion: nil)
            } else if let error = error {
                //Error has occurred
                let controller = UIAlertController(title: "Failure", message: "A problem has occurred. Check your internet connection.", preferredStyle: .alert)
                controller.addAction(UIAlertAction(title: "Okay",style: .cancel, handler: nil))
                self.present(controller, animated: true, completion: nil)
                print("\n***************ERROR***************")
                print(error)
                print("***************ERROR***************\n")
            }
        })
    }
}
