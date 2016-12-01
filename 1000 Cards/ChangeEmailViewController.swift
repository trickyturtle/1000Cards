//
//  SettingsViewController.swift
//  1000 Cards
//
//  Created by Isaac Garza on 11/3/16.
//  Copyright © 2016 Isaac Garza. All rights reserved.
//

import UIKit

class ChangeEmailViewController: UIViewController {

    @IBOutlet weak var newEmail: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func enterButton(_ sender: Any) {
        PFUser.current()?.email = newEmail.text
        let controller = UIAlertController(title: "Email Changed", message: "Your email has been updated to \(newEmail.text)", preferredStyle: .alert)
        controller.addAction(UIAlertAction(title: "OK",style: .default, handler: nil))
        self.present(controller, animated: true, completion: nil)

    }
}
