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
    
    @IBOutlet weak var titleTF: UITextField!
    @IBOutlet weak var descriptionTF: UITextView!
    @IBOutlet weak var deckImage: UIImageView!
    
    let imagePicker = UIImagePickerController()
    var newDeck = PFObject(className: "Deck")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(CreateNewCardView.imageTapped))
        imagePicker.delegate = self
        // add it to the image view;
        deckImage.addGestureRecognizer(tapGesture)
        // make sure imageView can be interacted with by user
        deckImage.isUserInteractionEnabled = true
        //deckImage = UIImage(named: "defaultImage.jpg")
        
    }
    
    @IBAction func updateDeckInfo(_ sender: AnyObject) {
        //handle empty input
        if((titleTF.text?.isEmpty)!){
            //TODO: Add alert
            print("no title for deck")
        }
        else{
            newDeck.add(titleTF.text!, forKey: "title")
            newDeck.add(descriptionTF.text, forKey: "description")
            newDeck.add(deckImage.image!, forKey: "image")
            newDeck.saveInBackground()
        }
    }

    func imageTapped() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary;
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            deckImage.contentMode = .scaleAspectFit
            deckImage.image = pickedImage
        }
        
        dismiss(animated: true, completion: nil)
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
