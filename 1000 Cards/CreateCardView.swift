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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(CreateNewCardView.imageTapped))
        imagePicker.delegate = self
        // add it to the image view;
        newCardImageView.addGestureRecognizer(tapGesture)
        // make sure imageView can be interacted with by user
        newCardImageView.isUserInteractionEnabled = true
        newCardImageView.image = UIImage(named: "defaultImage.jpg")
    }

    @IBAction func createCardButton(_ sender: AnyObject) {
        //handle empty input
        if((titleTF.text?.isEmpty)!){
            //TODO: Add alert
            print("no title for card")
        }
        else{
            let newCard = PFObject(className: "Card")
            newCard.add(titleTF.text!, forKey: "title")
            newCard.add(descriptionTF.text, forKey: "description")
            newCard.add(newCardImageView.image!, forKey: "image")
            newCard.saveInBackground()
            deck.add(newCard, forKey: "card")
            deck.saveInBackground()
        }

    }
    
//    func imageTapped(gesture: UIGestureRecognizer) {
    func imageTapped() {
        // if the tapped view is a UIImageView then set it to imageview
//        if let imageView = gesture.view as? UIImageView {
//
//            //Here you can initiate your new ViewController
//            
//        }
//        let image = UIImagePickerController()
//        image.delegate = self
//        image.sourceType = UIImagePickerControllerSourceType.photoLibrary
//        self.present(image, animated: true, completion: nil)
        
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary;
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
//    private func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
//        let imgInfo: NSDictionary = info as NSDictionary
//        let img: UIImage = imgInfo.object(forKey: UIImagePickerControllerOriginalImage) as! UIImage
//        newCardImageView.image = img
//        self.dismiss(animated: true, completion: nil)
//    }
    
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
