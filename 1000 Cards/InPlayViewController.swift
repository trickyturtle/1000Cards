
//
//  InPlayViewController.swift
//  1000 Cards
//
//  Created by Brian Shiau on 10/31/16.
//  Copyright © 2016 Isaac Garza. All rights reserved.
//
import Foundation
import UIKit

class InPlayViewController: GameCardCarouselView
{
    
    override func carousel(_ carousel: iCarousel, didSelectItemAt index: Int) {
        let vc : CardView = self.storyboard!.instantiateViewController(withIdentifier: "cardViewController") as! CardView
        do{
            try cardData = PFQuery.getObjectOfClass("Card", objectId: deckArray[index])
            vc.card = cardData
            vc.cardImage = cardImages[index]
            vc.currIndex = index
            vc.isInPlay = true
        } catch{
            // If an error occurs
            let nserror = error as NSError
            NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
            abort()
        }
        self.navigationController?.pushViewController(vc as UIViewController, animated: true)
    }
}

