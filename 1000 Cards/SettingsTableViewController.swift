//
//  SettingsTableViewController.swift
//  1000 Cards
//
//  Created by Isaac Garza on 11/3/16.
//  Copyright © 2016 Isaac Garza. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 2 {
            let controller = UIAlertController(title: "Logout", message: "Are you sure?", preferredStyle: .alert)
            controller.addAction(UIAlertAction(title: "No",style: .cancel, handler: nil))
            controller.addAction(UIAlertAction(title: "Yes",style: .default, handler: logout))
            self.present(controller, animated: true, completion: nil)
        }
    }
    
    func logout(action: UIAlertAction){
        PFUser.logOut()
        let vc : AnyObject! = self.storyboard!.instantiateViewController(withIdentifier: "navRoot")
        self.present(vc as! UINavigationController, animated: true, completion: nil)
    }

    @IBAction func deleteAccount(_ sender: Any) {
        let controller = UIAlertController(title: "Delete Account", message: "Are you sure? You cannot undo this action.", preferredStyle: .alert)
        controller.addAction(UIAlertAction(title: "No",style: .cancel, handler: nil))
        controller.addAction(UIAlertAction(title: "Yes",style: .default, handler: deleteAccount))
        self.present(controller, animated: true, completion: nil)
    }
    
    func deleteAccount(action: UIAlertAction){
        PFUser.current()?.deleteInBackground(block: { (deleteSuccessful, error) -> Void in
            print("success = \(deleteSuccessful)")
            PFUser.logOut()
            let vc : AnyObject! = self.storyboard!.instantiateViewController(withIdentifier: "navRoot")
            self.present(vc as! UINavigationController, animated: true, completion: nil)
        })
    }

}
