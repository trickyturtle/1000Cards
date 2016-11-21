//
//  CreateNewGameViewController.swift
//  1000 Cards
//
//  Created by Katherine Heyne on 10/20/16.
//  Copyright © 2016 Katherine Heyne. All rights reserved.
//

import UIKit

class CreateNewGameViewController: UIViewController {
    
    @IBOutlet weak var gameNameTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if (identifier == "createGameSegue") {
            if (gameNameTF.text?.isEmpty == true) {
                let controller = UIAlertController(title: "Missing Game Name", message: "Please add a name for your game.", preferredStyle: .alert)
                controller.addAction(UIAlertAction(title: "OK",style: .default, handler: nil))
                self.present(controller, animated: true, completion: nil)
                return false
            }
                //                let newGame = PFObject(className: "Game")
                //                newGame["name"] = gameNameTF.text
                //                newGame["description"] = gameDescriptionTF.text
                //                newGame.saveInBackground(block: { succeed, error in
                //                    if (succeed) {
                //                        //create game was successful
                //                        let vc : GameContainerView = self.storyboard!.instantiateViewController(withIdentifier: "gameContainerView") as! GameContainerView
                //                        vc.game = newGame
                //                        self.navigationController?.pushViewController(vc as UIViewController, animated: true)
                //                    } else if let error = error {
                //                        //Error has occurred
                //                        print("\n***************ERROR***************")
                //                        print(error)
                //                        print("***************ERROR***************\n")
                //                    }
                //                })
        }
        return true;
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "createGameSegue") {
            let inviteTableVC = segue.destination as! InviteTableViewController;
            inviteTableVC.gameTitle =  gameNameTF.text!
        }
    }
    
}
