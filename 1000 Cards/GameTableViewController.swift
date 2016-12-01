//
//  ViewController.swift
//  1000 Cards
//
//  Created by Katherine Heyne on 10/11/16.
//  Copyright © 2016 Katherine Heyne. All rights reserved.
//

import UIKit

class GameTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var sampleGame = ["Sample Game"]
    
    @IBOutlet weak var currentGamesTableView: UITableView!
    
    let cellIdentifier = "gameCell"
    var games = [PFObject]()
    var selectedGame: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let gameQuery = PFQuery(className: "Game")
        gameQuery.whereKey("players", equalTo: PFUser.current()!)
        gameQuery.order(byDescending: "createdAt")
        DispatchQueue.global().async {
            do {
                self.games = try gameQuery.findObjects()
                if (self.currentGamesTableView != nil) {
                    DispatchQueue.main.async {
                        self.currentGamesTableView.reloadData()}
                }
            } catch {
                print("\n***************ERROR***************")
                print(error)
                print("***************ERROR***************\n")
            }
        }
        setTabBarVisible(visible: true, animated: true)
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
        return games.count
    }
    
    //what to display in the table: first name and last name and num votes for each candidate
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath as IndexPath)
        let row = indexPath.row
        let rowGameName = games[row].object(forKey: "name") as! String
        let rowGameDescription = games[row].object(forKey: "description") as! String
        //text side of cell is game's name
        cell.textLabel?.text = rowGameName
        //detail side of cell is game's description
        cell.detailTextLabel?.text = rowGameDescription
        return cell
    }
    
    // MARK: - Navigation
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let game = games[indexPath.row]
        let vc : GameContainerView = self.storyboard!.instantiateViewController(withIdentifier: "gameContainerView") as! GameContainerView
        vc.game = game as PFObject!
        setTabBarVisible(visible: false, animated: true)
        self.navigationController?.pushViewController(vc as UIViewController, animated: true)
    }
    
    func setTabBarVisible(visible:Bool, animated:Bool) {
        
        //* This cannot be called before viewDidLayoutSubviews(), because the frame is not set before this time
        
        // bail if the current state matches the desired state
        if (tabBarIsVisible() == visible) { return }
        
        // get a frame calculation ready
        let frame = self.tabBarController?.tabBar.frame
        let height = frame?.size.height
        let offsetY = (visible ? -height! : height)
        
        // zero duration means no animation
        let duration:TimeInterval = (animated ? 0.3 : 0.0)
        
        //  animate the tabBar
        if frame != nil {
            UIView.animate(withDuration: duration) {
                self.tabBarController?.tabBar.frame = frame!.offsetBy(dx: 0, dy: offsetY!)
                return
            }
        }
    }
    
    func tabBarIsVisible() ->Bool {
        return (self.tabBarController?.tabBar.frame.origin.y)! < self.view.frame.maxY
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "createNewGameSegue") {
            setTabBarVisible(visible: false, animated: true)
        }
    }
}
