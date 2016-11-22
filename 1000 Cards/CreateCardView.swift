//
//  CreateCardView.swift
//  1000 Cards
//
//  Created by David Alexander on 11/2/16.
//  Copyright © 2016 Isaac Garza. All rights reserved.
//

import Foundation
import UIKit

class CreateNewCardView: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    //MARK: Properties
    @IBOutlet weak var titleTF: UITextField!
    @IBOutlet weak var descriptionTF: UITextView!
    @IBOutlet weak var newCardImageView: UIImageView!
    let imagePicker = UIImagePickerController()
    var deck = PFObject(className: "Deck")
    
    // if called from game
    var game = PFObject(className: "Deck")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(CreateNewCardView.imageTapped))
        imagePicker.delegate = self
        // add it to the image view;
        newCardImageView.addGestureRecognizer(tapGesture)
        // make sure imageView can be interacted with by user
        newCardImageView.isUserInteractionEnabled = true
        //newCardImageView.image = UIImage(named: "defaultImage.jpg") //TODO: replace with label
    }

    @IBAction func createCardButton(_ sender: AnyObject) {
        //handle empty input
        if((titleTF.text?.isEmpty)!){
            //TODO: Add alert
            print("no title for card")
        }
        else{
            let newCard = PFObject(className: "Card")
            newCard["title"] = titleTF.text!
            newCard["description"] = descriptionTF.text
            newCard["image"] = CardReader.imageToParseFile(image: newCardImageView.image!, title: titleTF.text!)
            do {
                //newCard["createdBy"] = PFUser.current()
                try newCard.save()
            } catch {
                    print(error)
            }
            //TODO: error handle adding card to deck
            CardReader.saveImageToDocumentDirectory(image: newCardImageView.image!, parseID: newCard.objectId!)
            if (deck.objectId == nil) { // we are creating card for game
                let relation = game.relation(forKey: "cards")
                relation.add(newCard)
                game.saveInBackground()
                
                // save to all cards deck
                let user = PFUser.current()
                let query = PFQuery(className: "Deck")
                query.getObjectInBackground(withId: user?["allCardsDeckId"] as! String, block: { (object: PFObject?, error: Error?) -> Void in
                    if error != nil || object == nil {
                        print("The getFirstObject request failed.")
                    } else {
                        // The find succeeded.
                        let relation = object?.relation(forKey: "cards")
                        relation?.add(newCard)
                        object?.saveInBackground()
                    }
                })
            } else {
                let relation = deck.relation(forKey: "cards")
                relation.add(newCard)
                deck.saveInBackground()
                
                // save to all cards deck
                let user = PFUser.current()
                let query = PFQuery(className: "Deck")
                query.getObjectInBackground(withId: user?["allCardsDeckId"] as! String, block: { (object: PFObject?, error: Error?) -> Void in
                    if error != nil || object == nil {
                        print("The getFirstObject request failed.")
                    } else {
                        // The find succeeded.
                        let relation = object?.relation(forKey: "cards")
                        relation?.add(newCard)
                        object?.saveInBackground()
                    }
                })
            }
            NotificationCenter.default.post(name: Notification.Name(rawValue: "addedCard"), object: nil, userInfo: ["newCard": newCard.objectId!])
            
            _ = self.navigationController?.popViewController(animated: true)
        }

    }
    

    func imageTapped() {

        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary;
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            newCardImageView.contentMode = .scaleAspectFit
            newCardImageView.image = pickedImage
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
