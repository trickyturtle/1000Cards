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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let title = gameNameTF.text!
        if (segue.identifier == "createGameSegue" && !title.isEmpty) {
            let inviteTableVC = segue.destination as! InviteTableViewController;
            inviteTableVC.gameTitle =  title
        } else {
            let controller = UIAlertController(title: "Missing Game Name", message: "Please add a name for your game.", preferredStyle: .alert)
            controller.addAction(UIAlertAction(title: "OK",style: .default, handler: nil))
            self.present(controller, animated: true, completion: nil)
        }
    }
    
}
