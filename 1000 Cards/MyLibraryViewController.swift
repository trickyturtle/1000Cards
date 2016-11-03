//
//  MyLibraryViewController.swift
//  1000 Cards
//
//  Created by Isaac Garza on 10/20/16.
//  Copyright © 2016 Isaac Garza. All rights reserved.
//

import UIKit

class MyLibraryViewController: UIViewController, UITableViewDataSource {

    var sampleLibrary = ["Sample Deck"]
    @IBAction func createNewDeck(_ sender: AnyObject) {
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
