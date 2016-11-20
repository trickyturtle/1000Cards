//
//  GameView.swift
//  1000-Cards
//
//  Created by David Alexander on 10/19/16.
//  Copyright © 2016 EggLord. All rights reserved.
//

import UIKit

class GameContainerView: UIViewController {
    
    var game: PFObject!
    
    @IBOutlet weak var containerViewGame: UIView!
    @IBOutlet weak var containerViewHand: UIView!
    @IBOutlet weak var containerViewDiscard: UIView!
    @IBOutlet weak var containerViewInPlay: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func showComponent(sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            UIView.animate(withDuration: 0.5, animations: {
                self.containerViewGame.alpha = 1
                self.containerViewHand.alpha = 0
                self.containerViewDiscard.alpha = 0
                self.containerViewInPlay.alpha = 0
            })
        } else if sender.selectedSegmentIndex == 1 {
            UIView.animate(withDuration: 0.5, animations: {
                self.containerViewGame.alpha = 0
                self.containerViewHand.alpha = 1
                self.containerViewDiscard.alpha = 0
                self.containerViewInPlay.alpha = 0
            })
        } else if sender.selectedSegmentIndex == 2 {
            UIView.animate(withDuration: 0.5, animations: {
                self.containerViewGame.alpha = 0
                self.containerViewHand.alpha = 0
                self.containerViewDiscard.alpha = 1
                self.containerViewInPlay.alpha = 0
            })
        } else if sender.selectedSegmentIndex == 3 {
            UIView.animate(withDuration: 0.5, animations: {
                self.containerViewGame.alpha = 0
                self.containerViewHand.alpha = 0
                self.containerViewDiscard.alpha = 0
                self.containerViewInPlay.alpha = 1
            })
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
        if (segue.identifier == "messageBoardSegue") {
            let messageBoard = segue.destination as! MessageBoardViewController;
            messageBoard.gameId = game.value(forKey: "objectId") as! String
        }
    }
}