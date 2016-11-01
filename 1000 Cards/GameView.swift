//
//  GameView.swift
//  1000-Cards
//
//  Created by David Alexander on 10/19/16.
//  Copyright © 2016 EggLord. All rights reserved.
//

import UIKit

class GameView: UIViewController {
    @IBOutlet weak var containerViewGame: UIView!
    @IBOutlet weak var containerViewHand: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func showComponent(sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            UIView.animate(withDuration: 0.5, animations: {
                self.containerViewGame.alpha = 1
                self.containerViewHand.alpha = 0
            })
        } else {
            UIView.animate(withDuration: 0.5, animations: {
                self.containerViewGame.alpha = 0
                self.containerViewHand.alpha = 1
            })
        }
    }
}
