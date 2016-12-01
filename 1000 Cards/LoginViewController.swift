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
        let currentUser = PFUser.current()
        if currentUser != nil {
            if currentUser!["emailVerified"] as! Bool == true {
                let vc : AnyObject! = self.storyboard!.instantiateViewController(withIdentifier: "tabRoot")
                self.navigationController?.setNavigationBarHidden(true, animated: true)
                self.navigationController?.pushViewController(vc as! UITabBarController, animated: true)
            } else {
                let controller = UIAlertController(title: "Email not verified", message: "Please ensure that you have verified your email. The email containing the verification link should be in your inbox.", preferredStyle: .alert)
                controller.addAction(UIAlertAction(title: "OK",style: .default, handler: nil))
                self.present(controller, animated: true, completion: nil)
            }
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
                let controller = UIAlertController(title: "Login error occured", message: "Please ensure that your username and password were entered correctly.", preferredStyle: .alert)
                controller.addAction(UIAlertAction(title: "OK",style: .default, handler: nil))
                self.present(controller, animated: true, completion: nil)
            }
        }
    }

}
