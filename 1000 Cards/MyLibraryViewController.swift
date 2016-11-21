//
//  MyLibraryViewController.swift
//  1000 Cards
//
//  Created by Isaac Garza on 10/20/16.
//  Copyright © 2016 Isaac Garza. All rights reserved.
//

import UIKit

class MyLibraryViewController: UIViewController, UITableViewDataSource {

    var sampleLibrary: [String] = []
    @IBAction func createNewDeck(_ sender: AnyObject) {
        //Save deck in Parse
        let newDeck = PFObject(className: "Deck")
        do {
            try newDeck.save()
        }catch{
            print("ERROR SAVING DECK")
            // If an error occurs
            let nserror = error as NSError
            NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
            abort()
        }

        //Save deck parse ID locally
        print(newDeck.objectId!)
        GameAction.saveDeckLocally(parseID: newDeck.objectId!)
        //segue to deckinfoView
        let vc : DeckViewController = self.storyboard!.instantiateViewController(withIdentifier: "DeckView") as! DeckViewController
        vc.deckID = newDeck.objectId! as String!
        //setTabBarVisible(visible: false, animated: true)
        self.navigationController?.pushViewController(vc as UIViewController, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
        return sampleLibrary.count
    }
    
    //what to display in the table: first name and last name and num votes for each candidate
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myLibraryCell", for: indexPath as IndexPath)
        let row = indexPath.row
        cell.textLabel?.text = sampleLibrary[row]
        return cell
    }

}
