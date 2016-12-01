//
//  GameAction.swift
//  1000 Cards
//
//  Created by David Alexander on 11/17/16.
//  Copyright © 2016 Isaac Garza. All rights reserved.
//
import Foundation
import UIKit
import CoreData


class GameAction{
    
    static func getCurrentGame()->String{
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CurrentGame")
        var fetchedResults:[NSManagedObject]
        
        do {
            try fetchedResults = managedContext.fetch(fetchRequest) as! [CurrentGame]
            
            return fetchedResults[0].value(forKey: "gameID") as! String
            
        }catch {
            // If an error occurs
            let nserror = error as NSError
            NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
            abort()
        }
    }
    
    static func createActionMessage(player: String, source: String, action: String, dest: String)->String{
        let actionMessage = PFObject(className: "ActionMessage")
        
        //TODO refactor this
        actionMessage["source"] = source
        actionMessage["player"] = player
        actionMessage["action"] = action
        actionMessage["destination"] = dest
        actionMessage.saveInBackground()
        return actionMessage.objectId!
    }
    
    static func formatAMForPrint(actionMessage: PFObject)->String{
//        var actionMessage: PFObject
//        do {actionMessage = try PFQuery.getObjectOfClass("ActionMessage", objectId: messageID)
//        }catch {
//            // If an error occurs
//            let nserror = error as NSError
//            NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
//            NSLog("while getting ActionMessage object")
//            abort()
//        }
        
        //TODO: we probably expect a player ID and convert it into a username
        let name:String = actionMessage["player"] as! String
        let source:String = actionMessage["source"] as! String
        let action:String = actionMessage["action"] as! String
        let dest:String
            = actionMessage["dest"] as! String
        
        if (action == "pop"){
            if (source == "deck"){
                return "\(name) drew a card"
            }
        }
        else{
            var cardTitle:String = ""
            if (source == "hand"){
                cardTitle = CardReader.getCardTitle(parseID: action)
                return "\(name) played \(cardTitle)"
            }
            else if (source == "inPlay" && dest == "discard"){
                cardTitle = CardReader.getCardTitle(parseID: action)
                return "\(name) discarded \(cardTitle)"
            }
            else if (dest == "deck"){
                return "\(name) added a card to the deck"
            }
        }
        
        //should never run
        return "Turn Action Error"
    }
    
    
    static func getPreLoadedDeck(){
        //TODO: WIP
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        let managedContext = appDelegate.managedObjectContext
//        
//        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "PreLoadedDeck")
//        var fetchedResults:[NSManagedObject]
//        
//        do {
//            try fetchedResults = managedContext.fetch(fetchRequest) as! [PreLoadedDeck]
//            if fetchedResults.count == 0{
//                let newDeck = PFObject(className: "Deck")
//                newDeck.saveEventually()
//            }
//            
//            return fetchedResults[0].value(forKey: "deckID") as! String
//            
//        }catch {
//            // If an error occurs
//            let nserror = error as NSError
//            NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
//            abort()
//        }
//    }
    }
}
