//
//  PublicLibraryViewController.swift
//  1000 Cards
//
//  Created by Brian Shiau on 11/20/16.
//  Copyright © 2016 Isaac Garza. All rights reserved.
//

import UIKit

class PublicLibraryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate  {
    
    var game = PFObject(className: "Game")
    var choosingDeck = false
    var sampleLibrary = ["Sample Deck"]
    var publicDecks = [PFObject]()
    
    @IBOutlet weak var publicLibraryTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        publicLibraryTableView.delegate = self
        publicLibraryTableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let gameQuery = PFQuery(className: "Deck")
        gameQuery.whereKey("public", equalTo: true)
        gameQuery.order(byDescending: "createdAt")
        DispatchQueue.global().async {
            do {
                self.publicDecks = try gameQuery.findObjects()
                if (self.publicLibraryTableView != nil) {
                    DispatchQueue.main.async {
                        self.publicLibraryTableView.reloadData()}
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
    
    //set number of rows in table view to be number of candidates
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return publicDecks.count
    }
    
    //what to display in the table
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "publicLibraryCell", for: indexPath as IndexPath)
        let row = indexPath.row
        cell.textLabel?.text = publicDecks[row].object(forKey: "title") as? String
        return cell
    }

    // MARK: - Navigation
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let deck = publicDecks[indexPath.row]
        
        if(choosingDeck) {
            game["gameDeck"] = deck
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
            let vc : PublicDeckView = self.storyboard!.instantiateViewController(withIdentifier: "PublicDeckView") as! PublicDeckView
            vc.deckTitle = deck["title"] as! String
            self.navigationController?.pushViewController(vc as CardCarouselView, animated: true)
        }
    }
}
