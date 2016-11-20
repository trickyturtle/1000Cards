//
//  PublicLibraryViewController.swift
//  1000 Cards
//
//  Created by Brian Shiau on 11/20/16.
//  Copyright © 2016 Isaac Garza. All rights reserved.
//

import UIKit

class PublicLibraryViewController: UIViewController, UITableViewDataSource {

    var sampleLibrary = ["Sample Deck"]
    var decks = [PFObject]()
    
    @IBOutlet weak var publicLibraryTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let gameQuery = PFQuery(className: "Deck")
        gameQuery.whereKey("public", equalTo: true)
        gameQuery.order(byDescending: "createdAt")
        DispatchQueue.global().async {
            do {
                self.decks = try gameQuery.findObjects()
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
        //setTabBarVisible(visible: true, animated: true)
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
        return decks.count
    }
    
    //what to display in the table
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "publicLibraryCell", for: indexPath as IndexPath)
        let row = indexPath.row
        cell.textLabel?.text = decks[row].object(forKey: "title") as? String
        return cell
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
