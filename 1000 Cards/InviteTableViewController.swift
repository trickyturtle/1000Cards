//
//  InviteTableViewController.swift
//  1000 Cards
//
//  Created by Isaac Garza on 11/16/16.
//  Copyright © 2016 Isaac Garza. All rights reserved.
//

import UIKit

class InviteTableViewController: UITableViewController {
    
    var currentUser = PFUser.current()!
    var recentUsersArr = [PFUser]()
    var gameTitle = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        // TODO: Make recentUser relation
        //recentUsersArr = currentUser?.value(forKey: "recentPlayers") as! [PFUser]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //First Call Super
        super.viewWillAppear(animated)
        
        //Register the Custom DataCell
        self.tableView.register(InviteTableCell.classForCoder(), forCellReuseIdentifier: "inviteCell")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    
    @IBAction func doneButton(_ sender: Any) {
        let player2TF = self.tableView.viewWithTag(2) as! UITextField
        let player3TF = self.tableView.viewWithTag(3) as! UITextField
        let player4TF = self.tableView.viewWithTag(4) as! UITextField

        if (player2TF.text! == "" && player3TF.text! == "" && player4TF.text! == "") {
            // TODO: Alert to confirm no invites
            createGame(player2: nil, player3: nil, player4: nil)
        } else {
            // Check valid username
            var query = PFUser.query()
            var player2: PFUser? = nil, player3: PFUser? = nil, player4: PFUser? = nil
            DispatchQueue.global().async {
                do {
                   player2 = try query?.whereKey("username", equalTo: player2TF.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)).getFirstObject() as? PFUser
                } catch {
                    print("\n***************ERROR***************")
                    print(error)
                    print("***************ERROR***************\n")
                }
                query = PFUser.query()
                do {
                    player3 = try query?.whereKey("username", equalTo: player3TF.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)).getFirstObject() as? PFUser
                } catch {
                    print("\n***************ERROR***************")
                    print(error)
                    print("***************ERROR***************\n")
                }
                query = PFUser.query()
                do {
                    player4 = try query?.whereKey("username", equalTo: player4TF.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)).getFirstObject() as? PFUser
                } catch {
                    print("\n***************ERROR***************")
                    print(error)
                    print("***************ERROR***************\n")
                }
                self.createGame(player2: player2, player3: player3, player4: player4)
            }
        }
    }
    
    func createGame(player2: PFUser!, player3: PFUser!, player4: PFUser! ){
        let newGame = PFObject(className: "Game")
        newGame["name"] = gameTitle
        
        // TODO: Remove last comma and space
        var description = ""
        let relation = newGame.relation(forKey: "players")
        relation.add(currentUser)
        description += (currentUser.username)! + ", "
        if (player2 != nil) {
            relation.add(player2)
            description += player2.username! + ", "
        }
        if (player3 != nil) {
            relation.add(player3)
            description += player3.username! + ", "
        }
        if (player4 != nil) {
            relation.add(player4)
            description += player4.username!
        }
        newGame["description"] = description
        DispatchQueue.global().async {
            newGame.saveInBackground(block: { succeed, error in
                if (succeed) {
                    //create game was successful
                    let vc : GameContainerView = self.storyboard!.instantiateViewController(withIdentifier: "gameContainerView") as! GameContainerView
                    vc.game = newGame
                    vc.newGame = true
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
