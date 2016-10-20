//
//  ViewController.swift
//  1000 Cards
//
//  Created by Isaac Garza on 10/11/16.
//  Copyright © 2016 Isaac Garza. All rights reserved.
//

import UIKit

class GamesViewController: UIViewController, UITableViewDataSource {
    
    var sampleGame = ["Sample Game"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sampleGame.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "gameCell", for: indexPath as IndexPath)
        
        let row = indexPath.row
        cell.textLabel?.text = sampleGame[row]
        cell.detailTextLabel?.text = "isg245, kfh293, BrianShiau, trickyturtle..."
        
        return cell
    }
}
