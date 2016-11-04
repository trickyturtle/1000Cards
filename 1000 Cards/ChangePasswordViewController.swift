//
//  ChangePasswordViewController.swift
//  1000 Cards
//
//  Created by Isaac Garza on 11/3/16.
//  Copyright © 2016 Isaac Garza. All rights reserved.
//

import UIKit

class ChangePasswordViewController: UIViewController {

    @IBOutlet weak var currentPassword: UITextField!
    @IBOutlet weak var newPassword: UITextField!
    @IBOutlet weak var newPasswordRetype: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func enterButton(_ sender: Any) {
        // Check that the passwords matched
        if (currentPassword.text != PFUser.current()?.password) {
            let controller = UIAlertController(title: "Password Incorrect", message: "Incorrectly entered current password.", preferredStyle: .alert)
            controller.addAction(UIAlertAction(title: "OK",style: .default, handler: nil))
            self.present(controller, animated: true, completion: nil)
        } else if (newPassword.text != newPasswordRetype.text) {
            let controller = UIAlertController(title: "New Password input error", message: "Passwords are not the same.", preferredStyle: .alert)
            controller.addAction(UIAlertAction(title: "OK",style: .default, handler: nil))
            self.present(controller, animated: true, completion: nil)
        } else {
            PFUser.current()?.password = newPassword.text
            let controller = UIAlertController(title: "Password Changed", message: "Your password has been updated!", preferredStyle: .alert)
            controller.addAction(UIAlertAction(title: "OK",style: .default, handler: nil))
            self.present(controller, animated: true, completion: nil)
        }
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
