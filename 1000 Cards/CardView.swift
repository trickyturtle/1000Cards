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
    
    var card = Card()
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cardDescription: UITextView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = card.title
        imageView.image = card.image
        cardDescription = card.cardDescription
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
