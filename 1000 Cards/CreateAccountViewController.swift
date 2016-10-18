//
//  SignUpViewController.swift
//  1000 Cards
//
//  Created by Isaac Garza on 10/11/16.
//  Copyright © 2016 Isaac Garza. All rights reserved.
//

import UIKit

class CreateAccountViewController: UIViewController {

    let homePageSegue = "CreateAccountSuccess"
    
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var usernameTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var retypePassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func createAccountButton(_ sender: AnyObject) {
        
        if (passwordTF.text != retypePassword.text) {
            let controller = UIAlertController(title: "Password input error", message: "Passwords are not the same.", preferredStyle: .alert)
            controller.addAction(UIAlertAction(title: "OK",style: .default, handler: nil))
            self.present(controller, animated: true, completion: nil)

        } else {
            let user = PFUser()
            user.username = usernameTF.text
            user.password = passwordTF.text
            user.email = emailTF.text
            user.signUpInBackground { succeeded, error in
                if (succeeded) {
                    //The registration was successful
                    let vc : AnyObject! = self.storyboard!.instantiateViewController(withIdentifier: "tabBarController")
                    self.navigationController?.setNavigationBarHidden(true, animated: true)
                    self.navigationController?.pushViewController(vc as! UIViewController, animated: true)
                } else if let error = error {
                    //Something bad has occurred
                    print("\n***************ERROR***************")
                    print(error)
                    print("***************ERROR***************\n")
                }
            }
        }
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
