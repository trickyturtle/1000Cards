//
//  MyLibraryViewController.swift
//  1000 Cards
//
//  Created by Isaac Garza on 10/20/16.
//  Copyright © 2016 Isaac Garza. All rights reserved.
//

import UIKit
import CoreData

class MyLibraryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var myDecks = [PFObject(className: "Deck")]
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func createNewDeck(_ sender: AnyObject) {
        //Save deck in Parse
        let newDeck = PFObject(className: "Deck")
        do {
            newDeck["createdBy"] = PFUser.current()
            try newDeck.save()
        } catch{
            print("ERROR SAVING DECK")
            // If an error occurs
            let nserror = error as NSError
            NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
            abort()
        }
        let vc : DeckViewController = self.storyboard!.instantiateViewController(withIdentifier: "DeckView") as! DeckViewController
        vc.deck = newDeck
        vc.deckID = newDeck.objectId! as String!
        self.navigationController?.pushViewController(vc as CardCarouselView, animated: true)

        //Save deck parse ID locally

//        saveDeckLocally(parseID: newDeck.objectId!)
        //segue to deckinfoView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let deckQuery = PFQuery(className: "Deck")
        deckQuery.whereKey("createdBy", equalTo: PFUser.current()!)
        deckQuery.order(byAscending: "createdAt")
        DispatchQueue.global().async {
            do {
                self.myDecks = try deckQuery.findObjects()
                if (self.tableView != nil) {
                    DispatchQueue.main.async {
                        self.tableView.reloadData()}
                }
            } catch {
                print("\n***************ERROR***************")
                print(error)
                print("***************ERROR***************\n")
            }
        }
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //set number of sections in the table view to 1
    private func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myDecks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myLibraryCell", for: indexPath as IndexPath)
        let row = indexPath.row
        cell.textLabel?.text = myDecks[row].value(forKey: "title") as? String
        return cell
    }
    
    // MARK: - Navigation
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let deck = myDecks[indexPath.row]
        
        if(indexPath.row == 0) {
            let vc : AllPrivateCardsView = self.storyboard!.instantiateViewController(withIdentifier: "AllCardsView") as! AllPrivateCardsView
            vc.deck = deck
            vc.viewing = true
            self.navigationController?.pushViewController(vc as CardCarouselView, animated: true)
        } else {
            let vc : DeckViewController = self.storyboard!.instantiateViewController(withIdentifier: "DeckView") as! DeckViewController
            vc.deck = deck
            self.navigationController?.pushViewController(vc as CardCarouselView, animated: true)
        }
        
    }
    
//    func saveDeckLocally(parseID: String) {
//        print("parseID = \(parseID)")
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        let managedContext = appDelegate.managedObjectContext
//        
//        let entity =  NSEntityDescription.entity(forEntityName: "Deck",
//                                                 in:managedContext)
//        
//        let deck = NSManagedObject(entity: entity!,
//                                   insertInto: managedContext)
//        
//        deck.setValue(parseID, forKey: "parseID")
//        
//        
//        do {
//            try managedContext.save()
//            
//            //decks.append(deck)
//        } catch let error as NSError  {
//            print("Could not save \(error), \(error.userInfo)")
//        }
//    }

}
