//
//  AllPrivateCardsView.swift
//  1000 Cards
//
//  Created by Isaac Garza on 11/22/16.
//  Copyright © 2016 Isaac Garza. All rights reserved.
//

import Foundation
class AllPrivateCardsView: CardCarouselView {
    
    var viewing = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "All Cards"
        self.navigationItem.rightBarButtonItem = nil
    }
    
    override func carousel(_ carousel: iCarousel, didSelectItemAt index: Int) {
        if(!viewing) {
            do{
                try cardData = PFQuery.getObjectOfClass("Card", objectId: deckArray[index])
                
            } catch{
                // If an error occurs
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
            
            NotificationCenter.default.post(name: Notification.Name(rawValue: "addedCard"), object: nil, userInfo: ["newCard": cardData.objectId!])
        } else {
            let vc : CardView = self.storyboard!.instantiateViewController(withIdentifier: "cardViewController") as! CardView
            do{
                try cardData = PFQuery.getObjectOfClass("Card", objectId: deckArray[index])
                vc.card = cardData
                vc.cardImage = cardImages[index]
                vc.currIndex = index
                vc.calledByAllCards = true
            } catch{
                // If an error occurs
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
            self.navigationController?.pushViewController(vc as UIViewController, animated: true)
        }
        
    }
    
}
