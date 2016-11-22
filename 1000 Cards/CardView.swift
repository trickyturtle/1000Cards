//
//  CreateCardView.swift
//  1000 Cards
//
//  Created by David Alexander on 11/2/16.
//  Copyright © 2016 Isaac Garza. All rights reserved.
//

import Foundation
import UIKit

class CardView: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    var currIndex = 0 //default
    var currDeck = PFObject(className: "Deck")
    var card = PFObject(className: "Card")
    var cardImage: UIImage? = nil
    var calledByAllCards = false
    var isHand = false
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cardDescription: UITextView!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = card.object(forKey: "title") as! String?
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.image = cardImage
        cardDescription.contentMode = .bottomLeft
        cardDescription.text = card.object(forKey: "description") as! String?
        
        if (isHand) {
            let play  = UIBarButtonItem(barButtonSystemItem: .play, target: self, action: #selector(CardView.playBtn))
            self.navigationItem.rightBarButtonItem = play
        } else {
            let trash  = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(CardView.trashBtn))
            self.navigationItem.rightBarButtonItem = trash
        }
    }
    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func trashBtn() {
        // TODO: Alert to confirm
        if (!calledByAllCards){
            let relation = currDeck.relation(forKey: "cards")
            relation.remove(card)
            do {
                try currDeck.save()
            } catch {
                print(error)
            }
            
            NotificationCenter.default.post(name: Notification.Name(rawValue: "removedCard"), object: nil, userInfo: ["index": currIndex])
        } else {
            // TODO: Alert says warning action cannot be undone
            card.deleteEventually()
        }
        _ = self.navigationController?.popViewController(animated: true)

    }
    
    func playBtn() {
        NotificationCenter.default.post(name: Notification.Name(rawValue: "playedCard"), object: nil, userInfo: ["cardPlayed": card])
        _ = self.navigationController?.popViewController(animated: true)
        
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
