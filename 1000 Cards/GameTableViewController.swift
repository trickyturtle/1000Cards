//
//  ViewController.swift
//  1000 Cards
//
//  Created by Katherine Heyne on 10/11/16.
//  Copyright © 2016 Katherine Heyne. All rights reserved.
//

import UIKit

class GameTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var currentGamesTableView: UITableView!
    
    let cellIdentifier = "gameCell"
    var games = [PFObject]()
    var selectedGame: String?
    var removeGameIndexPath: IndexPath? = nil
    
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
        let playerRelation = games[row].relation(forKey: "players")
        let relationQuery = playerRelation.query()
        var description: String = ""
        do {
            let players = try relationQuery.findObjects() as! [PFUser]
            for player in players {
                description += "\(player.username!), "
            }
        } catch {
            print(error)
        }
        let index = description.index(description.endIndex, offsetBy: -2)
        let rowGameDescription = description.substring(to: index)
        //text side of cell is game's name
        cell.textLabel?.text = rowGameName
        //detail side of cell is game's description
        cell.detailTextLabel?.text = rowGameDescription
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            removeGameIndexPath = indexPath
            let gameToRemove = games[indexPath.row]
            confirmRemoveGame(game: gameToRemove)
        }
    }
    
    func confirmRemoveGame(game: PFObject) {
        let alert = UIAlertController(title: "Remove Game", message: "Are you sure you want to permanently delete \(game["name"] as! String)?", preferredStyle: .actionSheet)
        
        let removeAction = UIAlertAction(title: "Remove Game", style: .destructive, handler: handleRemoveGame)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { action in self.removeGameIndexPath = nil})
        
        alert.addAction(removeAction)
        alert.addAction(cancelAction)
        
        // Support display in iPad
        alert.popoverPresentationController?.sourceView = self.view
        alert.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.size.width / 2.0, y: self.view.bounds.size.height / 2.0, width: 1.0, height: 1.0)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func handleRemoveGame(alertAction: UIAlertAction!) -> Void {
        if let indexPath = removeGameIndexPath {
            currentGamesTableView.beginUpdates()
            let gameToUpdate = games[indexPath.row]
            let playerRelation = gameToUpdate.relation(forKey: "players")
            let relationQuery = playerRelation.query()
            relationQuery.findObjectsInBackground(block: { (objects: [PFObject]?, error: Error?) -> Void in
                if ((objects?.count)! > 1) {
                    for user in objects as! [PFUser] {
                        if user.objectId == PFUser.current()?.objectId {
                            playerRelation.remove(PFUser.current()!)
                        }
                    }
                } else {
                    gameToUpdate.deleteInBackground()
                }
            })
            findPlayerToRemove(game: gameToUpdate, username: (PFUser.current()?.username)!)
            gameToUpdate.saveInBackground()
            
            games.remove(at: indexPath.row)
            // Note that indexPath is wrapped in an array:  [indexPath]
            currentGamesTableView.deleteRows(at: [indexPath], with: .automatic)
            removeGameIndexPath = nil
            currentGamesTableView.endUpdates()
        }
    }
    
    func cancelRemoveGame(alertAction: UIAlertAction!) {
        removeGameIndexPath = nil
    }
    
    func findPlayerToRemove(game: PFObject, username: String) {
        if(game["player1"] as! String == username) {
            game["player1"] = ""
        } else if(game["player2"] as! String == username) {
            game["player2"] = ""
        } else if(game["player3"] as! String == username) {
            game["player3"] = ""
        } else {
            game["player4"] = ""
        }
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
