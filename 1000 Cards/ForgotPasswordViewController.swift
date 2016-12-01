//
//  ForgotPasswordViewController.swift
//  1000 Cards
//
//  Created by Isaac Garza on 10/12/16.
//  Copyright © 2016 Isaac Garza. All rights reserved.
//

import UIKit

class ForgotPasswordViewController: UIViewController {

    @IBOutlet weak var email: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func resetButton(_ sender: Any) {
        //Requires further testing
        PFUser.requestPasswordResetForEmail(inBackground: email.text!)
        let controller = UIAlertController(title: "Reset Email Sent", message: "An email to reset your password has been sent.", preferredStyle: .alert)
        controller.addAction(UIAlertAction(title: "OK",style: .default, handler: nil))
        self.present(controller, animated: true, completion: nil)
    }
}
