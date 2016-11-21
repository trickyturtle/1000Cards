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
        if let user = PFUser.current() {
            if user.isAuthenticated {
                //TODO: may need to save a preloaded deck here
                let vc : AnyObject! = self.storyboard!.instantiateViewController(withIdentifier: "tabBarController")
                self.navigationController?.setNavigationBarHidden(true, animated: true)
                self.navigationController?.pushViewController(vc as! UIViewController, animated: true)            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginButton(_ sender: AnyObject) {
        /********************** UNCOMMENT TO DISABLE LOGIN ***********************
        let vc : AnyObject! = self.storyboard!.instantiateViewController(withIdentifier: "tabBarController")
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.navigationController?.pushViewController(vc as! UIViewController, animated: true)
        ********************************************************************/
        
        /***************************************************************************
         *  This was commented out to allow you to use the application without a login
         *  If you would like, you may create an account by going to Create Account.
         ****************************************************************************/
        PFUser.logInWithUsername(inBackground: usernameTF.text!, password: passwordTF.text!) { user, error in
            if user != nil {
                //success
                
                //remove everything from the navigation stack
                
                let vc : AnyObject! = self.storyboard!.instantiateViewController(withIdentifier: "tabBarController")
                self.navigationController?.setNavigationBarHidden(true, animated: true)
                self.navigationController?.pushViewController(vc as! UIViewController, animated: true)
            } else if (error != nil) {
                //failure
                let controller = UIAlertController(title: "Login error occured", message: "Please ensure username and password entered correctly.", preferredStyle: .alert)
                controller.addAction(UIAlertAction(title: "OK",style: .default, handler: nil))
                self.present(controller, animated: true, completion: nil)
            }
        }
        /********************************************************************************/
    }

}
