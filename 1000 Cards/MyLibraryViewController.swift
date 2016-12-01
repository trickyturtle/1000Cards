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

    var game = PFObject(className: "Game")
    var choosingDeckForGame = false
    var myDecks = [PFObject(className: "Deck")]
    var deckForInfo = PFObject(className: "Deck")
    var deleteDeckIndexPath: IndexPath? = nil

    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func createNewDeck(_ sender: AnyObject) {
        //Save deck in Parse
        let newDeck = PFObject(className: "Deck")
        newDeck["createdBy"] = PFUser.current()
        newDeck["public"] = false
        newDeck["title"] = ""
        newDeck["description"] = ""
        let deckInfoView : DeckInfoView = self.storyboard!.instantiateViewController(withIdentifier: "deckInfo") as! DeckInfoView
        deckInfoView.deck = newDeck
        self.navigationController?.pushViewController(deckInfoView as UIViewController, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        if (choosingDeckForGame) {
            self.navigationItem.rightBarButtonItem = nil
        }
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
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        if !choosingDeckForGame && indexPath.row != 0 {
            return .delete
        }
        return .none
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteDeckIndexPath = indexPath
            let deckToDelete = myDecks[indexPath.row]
            confirmDeleteDeck(deck: deckToDelete)
        }
    }
    
    func confirmDeleteDeck(deck: PFObject) {
        let alert = UIAlertController(title: "Delete Deck", message: "Are you sure you want to permanently delete \(deck["title"] as! String)? This will not remove the cards from your \"All Cards\" deck.", preferredStyle: .actionSheet)
        
        let removeAction = UIAlertAction(title: "Delete Deck", style: .destructive, handler: handleDeleteDeck)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { action in self.deleteDeckIndexPath = nil})
        
        alert.addAction(removeAction)
        alert.addAction(cancelAction)
        
        // Support display in iPad
        alert.popoverPresentationController?.sourceView = self.view
        alert.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.size.width / 2.0, y: self.view.bounds.size.height / 2.0, width: 1.0, height: 1.0)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func handleDeleteDeck(alertAction: UIAlertAction!) -> Void {
        if let indexPath = deleteDeckIndexPath {
            tableView.beginUpdates()
            DispatchQueue.global().async {
                self.myDecks[indexPath.row].deleteInBackground()
            }
            
            myDecks.remove(at: indexPath.row)
            // Note that indexPath is wrapped in an array:  [indexPath]
            tableView.deleteRows(at: [indexPath], with: .automatic)
            deleteDeckIndexPath = nil
            tableView.endUpdates()
        }
    }
    
    // MARK: - Navigation
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let deck = myDecks[indexPath.row]
        deckForInfo = deck
        
        if(choosingDeckForGame) {
            let gameRelation = game.relation(forKey: "gameDeck")
            let deckRelation = deck.relation(forKey: "cards")
            let relationQuery = deckRelation.query()
            var result = [PFObject]()
            DispatchQueue.global().async {
                do {
                    result = try relationQuery.findObjects()
                } catch {
                    print(error)
                }
                for obj in result {
                    gameRelation.add(obj)
                }
            }
           
            DispatchQueue.global().async {
                self.game.saveInBackground(block: { succeed, error in
                    if (succeed) {
                        //create game was successful
                        let vc : GameContainerView = self.storyboard!.instantiateViewController(withIdentifier: "gameContainerView") as! GameContainerView
                        vc.game = self.game
                        self.navigationController?.pushViewController(vc as UIViewController, animated: true)
                    } else if let error = error {
                        //Error has occurred
                        print("\n***************ERROR***************")
                        print(error)
                        print("***************ERROR***************\n")
                    }
                })
            }
        } else {
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
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "deckInfoSegue",
            let destination = segue.destination as? DeckInfoView {
            destination.deck = deckForInfo
        }
    }
}
