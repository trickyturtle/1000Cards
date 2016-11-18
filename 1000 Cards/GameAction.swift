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
}
