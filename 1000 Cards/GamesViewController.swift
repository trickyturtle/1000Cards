//
//  ViewController.swift
//  1000 Cards
//
//  Created by Katherine Heyne on 10/11/16.
//  Copyright © 2016 Katherine Heyne. All rights reserved.
//

import UIKit

class GamesViewController: UIViewController, UITableViewDataSource {
    
    var sampleGame = ["Sample Game"]
    
    @IBOutlet weak var currentGamesTableView: UITableView!
    
    let cellIdentifier = "gameCell"
    //let user = PFUser.current()
    var currentGameNames = [PFObject]()
    var currentGameDescriptions = [String]()
    var selectedGame: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let gameQuery = PFQuery(className: "Game")
        gameQuery.order(byDescending: "createdAt")
        do {
            currentGameNames = try gameQuery.findObjects()
            if (currentGamesTableView != nil) {
                self.currentGamesTableView.reloadData()
            }
        } catch {
            print("\n***************ERROR***************")
            print(error)
            print("***************ERROR***************\n")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // To conform to UITableViewDataSource, you must implement
    // 3 methods:
    //    1.  numberOfSectionsInTableView
    //    2.  tableView:numberOfRowsInSection
    //    3.  tableView:cellForRowAtIndexPath
    //set number of sections in the table view to 1
    private func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    //set number of rows in table view to be number of candidates
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentGameNames.count
    }
    
    //what to display in the table: first name and last name and num votes for each candidate
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath as IndexPath)
        let row = indexPath.row
        let rowGameName = currentGameNames[row].object(forKey: "name") as! String
        let rowGameDescription = currentGameNames[row].object(forKey: "description") as! String
        //text side of cell is game's name
        cell.textLabel?.text = rowGameName
        //detail side of cell is game's description
        //cell.detailTextLabel?.font =
        cell.detailTextLabel?.text = rowGameDescription
        return cell
    }
}
