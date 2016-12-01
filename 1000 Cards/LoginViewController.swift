//
//  LoginViewController.swift
//  1000 Cards
//
//  Created by Isaac Garza on 10/12/16.
//  Copyright © 2016 Isaac Garza. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController {
    
    let homePageSegue = "LoginSuccess"
    
    @IBOutlet weak var usernameTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Check if user exists and logged in
        if PFUser.current() != nil {
            let vc : AnyObject! = self.storyboard!.instantiateViewController(withIdentifier: "tabRoot")
            self.navigationController?.setNavigationBarHidden(true, animated: true)
            self.navigationController?.pushViewController(vc as! UITabBarController, animated: true)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginButton(_ sender: AnyObject) {
        PFUser.logInWithUsername(inBackground: usernameTF.text!.lowercased(), password: passwordTF.text!) { user, error in
            if user != nil {
                //success
                let vc : AnyObject! = self.storyboard!.instantiateViewController(withIdentifier: "tabRoot")
                self.navigationController?.setNavigationBarHidden(true, animated: true)
                self.navigationController?.pushViewController(vc as! UITabBarController, animated: true)
            } else if (error != nil) {
                //failure
                let controller = UIAlertController(title: "Login error occured", message: "Please ensure username and password entered correctly.", preferredStyle: .alert)
                controller.addAction(UIAlertAction(title: "OK",style: .default, handler: nil))
                self.present(controller, animated: true, completion: nil)
            }
        }
    }

}
