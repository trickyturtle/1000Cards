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
        actionMessage.add(source, forKey: "source")
        actionMessage.add(player, forKey: "player")
        actionMessage.add(action, forKey: "action")
        actionMessage.add(dest, forKey: "destination")
        actionMessage.saveInBackground()
        return actionMessage.objectId!
    }
    
    static func formatAMForPrint(messageID: String)->String{
        //TODO: error handle
        let actionMessage = PFQuery.getObjectOfClass("ActionMessage", objectId: messageID)
        //TODO: we probably expect a player ID and convert it into a username
        let name:String = actionMessage.object(forKey: "player") as! String
        let source:String = actionMessage.object(forKey: "source") as! String
        let action:String = actionMessage.object(forKey: "action") as! String
        let dest:String
            = actionMessage.object(forKey: "dest") as! String
        
        if (action == "pop"){
            if (source == "deck"){
                return "\(name) drew a card"
            }
        }
        else{
            if (source == "hand"){
                //TODO error handling
                let cardTitle:String = (PFQuery.getObjectOfClass("Card", objectId: action).object(forKey: "title") as! String?)!
                return "\(name) played \(cardTitle)"
            }
            else if (source == "inPlay" && dest == "discard"){
                //TODO error handling
                let cardTitle:String = (PFQuery.getObjectOfClass("Card", objectId: action).object(forKey: "title") as! String?)!
                return "\(name) discarded \(cardTitle)"
            }
            else if (dest == "deck"){
                return "\(name) added a card to the deck"
            }
        }

        
    }
}
