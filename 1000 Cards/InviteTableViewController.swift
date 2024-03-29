//
//  InviteTableViewController.swift
//  1000 Cards
//
//  Created by Katherine Heyne on 11/18/16.
//  Copyright © 2016 Katherine Heyne. All rights reserved.
//

import UIKit

class InviteTableViewController: UITableViewController {
    
    var currentUser = PFUser.current()!
    var recentUsersArr = [String]()
    var gameTitle = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.register(InviteTableCell.classForCoder(), forCellReuseIdentifier: "inviteCell")
        
        let recentPlayers = currentUser["recentPlayers"]
        if (recentPlayers != nil) {
            let relation = recentPlayers as! PFRelation
            let query = relation.query()
            var result = [PFUser]()
            do {
                result = try query.findObjects() as! [PFUser]
            } catch {
                print(error)
            }
            for obj in result {
                recentUsersArr.append(obj.username!)
            }
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        if recentUsersArr.count != 0 {
            return 2
        }
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // First Section is 4 textfields
        if section == 0 {
            return 3
        } else {
            return recentUsersArr.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard var cell = tableView.dequeueReusableCell(withIdentifier: "inviteCell") else {
            return UITableViewCell()
        }
        
        if indexPath.section == 0 {
            cell = tableView.dequeueReusableCell(withIdentifier: "inviteCell") as! InviteTableCell
            let inviteTextField = UITextField(frame: CGRect(x: 8, y: 6, width: 359, height: 30))
            switch indexPath.row {
            case 0:
                inviteTextField.placeholder = "Player 2 Username"
                inviteTextField.accessibilityHint = "Player 2 Username"
                inviteTextField.tag = 2
                cell.addSubview(inviteTextField)
                break
            case 1:
                inviteTextField.placeholder = "Player 3 Username"
                inviteTextField.accessibilityHint = "Player 3 Username"
                inviteTextField.tag = 3
                cell.addSubview(inviteTextField)
                break
            case 2:
                inviteTextField.placeholder = "Player 4 Username"
                inviteTextField.accessibilityHint = "Player 4 Username"
                inviteTextField.tag = 4
                cell.addSubview(inviteTextField)
                break
            default:
                break
            }
        } else {
            //recent players table view
            let cell = tableView.dequeueReusableCell(withIdentifier: "recentPlayersCell", for: indexPath as IndexPath)
            let row = indexPath.row
            let rowRecentPlayer = recentUsersArr[row] 
            //text side of cell is player's username
            cell.textLabel?.text = rowRecentPlayer
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        switch section {
        case 0:
            return "New Players"
        case 1:
            return "Recent Players"
        default:
            return nil
        }
    }
    
    //for when you select a row in the table view
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            //then selected a recent player
            self.tableView.deselectRow(at: indexPath, animated: false)
            let row = indexPath.row
            //get current selected username
            let rowSelectedRecentPlayer = recentUsersArr[row]
            
            //add selected username to empty player textbox
            let player2TF = self.tableView.viewWithTag(2) as! UITextField
            let player3TF = self.tableView.viewWithTag(3) as! UITextField
            let player4TF = self.tableView.viewWithTag(4) as! UITextField
            
            if (player2TF.text! == "") {
                player2TF.text! = rowSelectedRecentPlayer
            } else if (player3TF.text! == "") {
                player3TF.text! = rowSelectedRecentPlayer
            } else {
                player4TF.text! = rowSelectedRecentPlayer
            }
        }
    }
    
    @IBAction func doneButton(_ sender: Any) {
        self.view.endEditing(true)
        let player2TF = self.tableView.viewWithTag(2) as! UITextField
        let player3TF = self.tableView.viewWithTag(3) as! UITextField
        let player4TF = self.tableView.viewWithTag(4) as! UITextField
        
        if (player2TF.text! == "" && player3TF.text! == "" && player4TF.text! == "") {
            let controller = UIAlertController(title: "No Invites", message: "Are you sure you don't want to invite anybody?", preferredStyle: .alert)
            controller.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
            controller.addAction(UIAlertAction(title: "Yes", style: .default, handler: {action in
                let newGame = self.createNewGameObject(player2: nil, player3: nil, player4: nil)
                let action = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
                let blankDeckAction = UIAlertAction(title: "Start With Blank Deck", style: .default) {(action) in
                    self.saveGame(newGame: newGame)
                }
                let myLibraryAction = UIAlertAction(title: "Start With Deck From My Library", style: .default) { (action) in
                    self.myLibraryDeck(newGame: newGame)
                }
                let publicLibraryAction = UIAlertAction(title: "Start With Deck From My Library", style: .default) { (action) in
                    self.publicLibraryDeck(newGame: newGame)
                }
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                
                action.addAction(blankDeckAction)
                action.addAction(myLibraryAction)
                action.addAction(publicLibraryAction)
                action.addAction(cancelAction)
                
                self.present(action, animated: true, completion: nil)
            }))
            self.present(controller, animated: true, completion: nil)
        } else {
            // Check valid username
            var query = PFUser.query()
            var player2: PFUser? = nil, player3: PFUser? = nil, player4: PFUser? = nil
            DispatchQueue.global().async {
                do {
                    player2 = try query?.whereKey("username", equalTo: player2TF.text!.lowercased().trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)).getFirstObject() as? PFUser
                } catch {
                    // TODO: Alert not error saying invalid user with specific username
                    print("\n***************ERROR***************")
                    print(error)
                    print("***************ERROR***************\n")
                }
                query = PFUser.query()
                do {
                    player3 = try query?.whereKey("username", equalTo: player3TF.text!.lowercased().trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)).getFirstObject() as? PFUser
                } catch {
                    print("\n***************ERROR***************")
                    print(error)
                    print("***************ERROR***************\n")
                }
                query = PFUser.query()
                do {
                    player4 = try query?.whereKey("username", equalTo: player4TF.text!.lowercased().trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)).getFirstObject() as? PFUser
                } catch {
                    print("\n***************ERROR***************")
                    print(error)
                    print("***************ERROR***************\n")
                }
                if (self.validUsers(player2: player2, player3: player3, player4: player4)) {
                    let newGame = self.createNewGameObject(player2: player2, player3: player3, player4: player4)
                    let action = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
                    let blankDeckAction = UIAlertAction(title: "Start With Blank Deck", style: .default) {(action) in
                        self.saveGame(newGame: newGame)
                    }
                    let myLibraryAction = UIAlertAction(title: "Start With Deck From My Library", style: .default) { (action) in
                        self.myLibraryDeck(newGame: newGame)
                    }
                    let publicLibraryAction = UIAlertAction(title: "Start With Deck From Public Library", style: .default) { (action) in
                        self.publicLibraryDeck(newGame: newGame)
                    }
                    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                    
                    action.addAction(blankDeckAction)
                    action.addAction(myLibraryAction)
                    action.addAction(publicLibraryAction)
                    action.addAction(cancelAction)
                    
                    self.present(action, animated: true, completion: nil)
                } else {
                    let controller = UIAlertController(title: "Invalid Users", message: "You inputted invalid username(s)", preferredStyle: .alert)
                    controller.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                    self.present(controller, animated: true, completion: nil)
                    print("invalid users")
                }
            }
        }
    }

    func validUsers(player2: PFUser!, player3: PFUser!, player4: PFUser!) -> Bool {
        let p2NotNil = player2 != nil
        let p3NotNil = player3 != nil
        let p4NotNil = player4 != nil
        if(p2NotNil && p3NotNil && player2.objectId == player3.objectId) {
            return false
        } else if (p2NotNil && p4NotNil && player2.objectId == player3.objectId) {
            return false
        } else if (p3NotNil && p4NotNil && player3.objectId == player3.objectId) {
            return false
        }
        return true
    }
    
    func myLibraryDeck(newGame: PFObject){
        let vc : MyLibraryViewController = self.storyboard!.instantiateViewController(withIdentifier: "myLibraryView") as! MyLibraryViewController
        vc.choosingDeckForGame = true
        vc.game = newGame
        self.navigationController?.pushViewController(vc as UIViewController, animated: true)
    }
    
    func publicLibraryDeck(newGame: PFObject){
        let vc : PublicLibraryViewController = self.storyboard!.instantiateViewController(withIdentifier: "publicLibraryView") as! PublicLibraryViewController
        vc.choosingDeck = true
        vc.game = newGame
        self.navigationController?.pushViewController(vc as UIViewController, animated: true)
    }
    
    func createNewGameObject(player2: PFUser!, player3: PFUser!, player4: PFUser!) -> PFObject {
        let newGame = PFObject(className: "Game")
        newGame["name"] = gameTitle
        
        newGame["player1"] = (currentUser.username)!
        
        var description = ""
        let relationGamePlayers = newGame.relation(forKey: "players")
        let relationRecentPlayers = currentUser.relation(forKey: "recentPlayers")
        relationGamePlayers.add(currentUser)
        description += (currentUser.username?.lowercased())!
        if (player2 != nil) {
            relationGamePlayers.add(player2)
            description +=  ", " + player2.username!
            newGame["player2"] = (player2.username)!
            relationRecentPlayers.add(player2)
        }
        if (player3 != nil) {
            relationGamePlayers.add(player3)
            description += ", " + player3.username!
            newGame["player3"] = (player3.username)!
            relationRecentPlayers.add(player3)
        }
        if (player4 != nil) {
            relationGamePlayers.add(player4)
            description += ", " + player4.username!
            newGame["player4"] = (player4.username)!
            relationRecentPlayers.add(player4)
        }
        currentUser.saveInBackground()
        
        newGame["description"] = description
        newGame["player1Score"] = "0"
        newGame["player2Score"] = "0"
        newGame["player3Score"] = "0"
        newGame["player4Score"] = "0"
        
        return newGame
    }
    
    func saveGame(newGame: PFObject){
        DispatchQueue.global().async {
            newGame.saveInBackground(block: { succeed, error in
                if (succeed) {
                    //create game was successful
                    let vc : GameContainerView = self.storyboard!.instantiateViewController(withIdentifier: "gameContainerView") as! GameContainerView
                    vc.game = newGame
                    self.navigationController?.pushViewController(vc as UIViewController, animated: true)
                } else if let error = error {
                    //Error has occurred
                    print("\n***************ERROR***************")
                    print(error)
                    print("***************ERROR***************\n")
                }
            })
        }
    }
}
