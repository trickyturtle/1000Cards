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
    
    @IBOutlet weak var titleTF: UITextField!
    @IBOutlet weak var descriptionTF: UITextView!
    @IBOutlet weak var publicSwitch: UISwitch!
    
    @IBAction func updateDeckInfo(_ sender: AnyObject) {
        //handle empty input
        if((titleTF.text?.isEmpty)!){
            //TODO: Add alert
            print("no title for deck")
        }
        else{
            deck["title"] = titleTF.text!
            deck["description"] = descriptionTF.text!
            deck["public"] = publicSwitch.isOn;
            deck.saveInBackground()
            // TODO: Alert that deck info was saved
            navigationItem.hidesBackButton = false
        }
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        if ((titleTF.text?.isEmpty)!) {
            navigationItem.hidesBackButton = true
        }
    }
    
    func infoTapped(){
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
