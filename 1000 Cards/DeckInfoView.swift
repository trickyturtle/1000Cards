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
    
    @IBAction func updateDeckInfo(_ sender: AnyObject) {
        //handle empty input
        if((titleTF.text?.isEmpty)!){
            //TODO: Add alert
            print("no title for deck")
        }
        else{
            let newDeck = PFObject(className: "Card")
            newDeck.add(titleTF.text, forKey: "title")
            newDeck.add(descriptionTF.text, forKey: "description")
            newDeck.add(deckImage.image, forKey: "image")
            newDeck.saveInBackground()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        let tapGesture = UITapGestureRecognizer(target: self, action: Selector(("imageTapped:")))
        
        // add it to the image view;
        deckImage.addGestureRecognizer(tapGesture)
        // make sure imageView can be interacted with by user
        deckImage.isUserInteractionEnabled = true
    }
    
    func imageTapped(gesture: UIGestureRecognizer) {
        // if the tapped view is a UIImageView then set it to imageview
        //        if let imageView = gesture.view as? UIImageView {
        //
        //            //Here you can initiate your new ViewController
        //
        //        }
        let image = UIImagePickerController()
        image.delegate = self
        image.sourceType = UIImagePickerControllerSourceType.photoLibrary
        self.present(image, animated: true, completion: nil)
        
    }
    
    private func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        let imgInfo: NSDictionary = info as NSDictionary
        let img: UIImage = imgInfo.object(forKey: UIImagePickerControllerOriginalImage) as! UIImage
        deckImage.image = img
        self.dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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