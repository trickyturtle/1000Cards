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
        /*
         * Uncomment to allow user login
         *
        if let user = PFUser.current() {
            if user.isAuthenticated {
                self.performSegue(withIdentifier: self.homePageSegue, sender: nil)
            }
        }*/
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginButton(_ sender: AnyObject) {
        /********************** TO DELETE ***********************
        let vc : AnyObject! = self.storyboard!.instantiateViewController(withIdentifier: "tabBarController")
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.navigationController?.pushViewController(vc as! UIViewController, animated: true)
        ********************************************************************/
        
        /*
        * Uncomment to allow user login
        */
        PFUser.logInWithUsername(inBackground: usernameTF.text!, password: passwordTF.text!) { user, error in
            if user != nil {
                //success
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
        /**/
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
