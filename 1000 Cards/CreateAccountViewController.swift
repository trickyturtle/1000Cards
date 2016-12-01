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
    let validUsername = true
    
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
        
        /********************** UNCOMMENT TO DISABLE CREATE ACCOUNT ***********************
        let vc : AnyObject! = self.storyboard!.instantiateViewController(withIdentifier: "instructionsDescriptions")
        var vcArray = self.navigationController?.viewControllers
        vcArray?.removeAll()
        vcArray?.append(vc as! UIViewController)
        self.navigationController?.viewControllers = vcArray!
        ********************************************************************/

        
        let email = emailTF.text?.lowercased().trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let username = usernameTF.text?.lowercased().trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        
        // Check that the passwords matched
        if (passwordTF.text != retypePassword.text) {
            let controller = UIAlertController(title: "Password input error", message: "Passwords are not the same.", preferredStyle: .alert)
            controller.addAction(UIAlertAction(title: "OK",style: .default, handler: nil))
            self.present(controller, animated: true, completion: nil)

        } else if (!isValidEmail(email: email!)) {
            let controller = UIAlertController(title: "Invalid email", message: "Please enter a valid email address.", preferredStyle: .alert)
            controller.addAction(UIAlertAction(title: "Okay",style: .default, handler: nil))
            self.present(controller, animated: true, completion: nil)
        } else {
            let query = PFUser.query()
            query?.whereKey("username", equalTo: username!)
            query?.findObjectsInBackground {
                (objects: [PFObject]?, error: Error?) in
                if error == nil {
                    if (objects!.count > 0){
                        let controller = UIAlertController(title: "Username Taken", message: "Please enter a valid username.", preferredStyle: .alert)
                        controller.addAction(UIAlertAction(title: "Okay",style: .default, handler: nil))
                        self.present(controller, animated: true, completion: nil)
                        print("username is taken")
                    } else {
                        // valid username, create account
                        self.createUser(email: email!, username: username!)
                    }
                } else {
                    let controller = UIAlertController(title: "Error", message: "Please check your internet connection.", preferredStyle: .alert)
                    controller.addAction(UIAlertAction(title: "Okay",style: .default, handler: nil))
                    self.present(controller, animated: true, completion: nil)
                    print("error")
                }
            }
        }
    }
    
    func isValidEmail(email: String) -> Bool {
        // print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
    
    func createUser(email: String, username: String) {
        let user = PFUser()
        user.username = username
        user.password = passwordTF.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        user.email = email
        user.signUpInBackground { succeeded, error in
            if (succeeded) {
                //The registration was successful
                
                //create all cards deck
                let allCardsDeck = PFObject(className: "Deck")
                do {
                    allCardsDeck["createdBy"] = user
                    allCardsDeck["title"] = "All Cards"
                    try allCardsDeck.save()
                } catch{
                    print("ERROR SAVING DECK")
                    // If an error occurs
                    let nserror = error as NSError
                    NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                    abort()
                }
                user["allCardsDeckId"] = allCardsDeck.objectId!
                user.saveInBackground()
                
                let vc : AnyObject! = self.storyboard!.instantiateViewController(withIdentifier: "instructionsDescriptions")
                var vcArray = self.navigationController?.viewControllers
                vcArray?.removeAll()
                vcArray?.append(vc as! UIViewController)
                self.navigationController?.viewControllers = vcArray!
            } else if let error = error {
                let controller = UIAlertController(title: "Error", message: "Please check your internet connection.", preferredStyle: .alert)
                controller.addAction(UIAlertAction(title: "Okay",style: .default, handler: nil))
                self.present(controller, animated: true, completion: nil)
                print("\n***************ERROR***************")
                print(error)
                print("***************ERROR***************\n")
            }
        }
    }
    
    @IBAction func instructDescriptButton(_ sender: AnyObject) {
        let vc : AnyObject! = self.storyboard!.instantiateViewController(withIdentifier: "tabRoot")
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.navigationController?.pushViewController(vc as! UITabBarController, animated: true)
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
