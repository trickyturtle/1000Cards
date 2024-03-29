//
//  HandViewController.swift
//  1000 Cards
//
//  Created by David Alexander on 10/31/16.
//  Copyright © 2016 Isaac Garza. All rights reserved.
//
import Foundation
import UIKit





class HandViewController: GameCardCarouselView
{

    //TODO: add IBOutlet carousel    
    @IBAction func createNewCard(_ sender: Any) {
        let vc : CreateNewCardView = self.storyboard!.instantiateViewController(withIdentifier: "createCard") as! CreateNewCardView
        vc.game = game
        self.navigationController?.pushViewController(vc as UIViewController, animated: true)
    }
    
    @IBAction func drawCard(_ sender: Any) {
        //add card to current players hand

        var relation = game.relation(forKey: "cards")
        let query = relation.query()
        var result = [PFObject]()
        do {
            result = try query.findObjects()
            let numCards = result.count
            if numCards == 0{
                let controller = UIAlertController(title: "Deck is empty!", message: "Create more cards!", preferredStyle: .alert)
                controller.addAction(UIAlertAction(title: "OK",style: .default, handler: nil))
                self.present(controller, animated: true, completion: nil)
            }else{
                let controller = UIAlertController(title: "Card Drawn!", message: "It may take a minute for your hand to update, depending on your network connection", preferredStyle: .alert)
                controller.addAction(UIAlertAction(title: "OK",style: .default, handler: nil))
                self.present(controller, animated: true, completion: nil)
                let card = result[Int(arc4random_uniform(UInt32(numCards)))]
                relation.remove(card)
                relation = game.relation(forKey: deckTypeKey)
                relation.add(card)
                //TODO: this needs to happen more quickly, we need save() and error handling or an alert
                    game.saveEventually()
            }

            
        } catch {
            print(error)
        }
        carousel.reloadData()

        
        
    }
    
    override func carousel(_ carousel: iCarousel, didSelectItemAt index: Int) {
        let vc : CardView = self.storyboard!.instantiateViewController(withIdentifier: "cardViewController") as! CardView
        do{
            try cardData = PFQuery.getObjectOfClass("Card", objectId: deckArray[index])
            vc.card = cardData
            vc.cardImage = cardImages[index]
            vc.currIndex = index
            vc.isHand = true
        } catch{
            // If an error occurs
            let nserror = error as NSError
            NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
            abort()
        }
        self.navigationController?.pushViewController(vc as UIViewController, animated: true)
    }
    
    static func getPlayerHandNum(game: PFObject)->Int{
        var i = 1
        while i < 5{
            if (PFUser.current()!.username! == game["player\(i)"]! as! String){
                return i
            }
            i += 1
        }
        return 0 //the player does not exist in the game
    }
    
  
}
