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
    var playerArray:[PFUser] = []
    
    @IBOutlet weak var containerViewGame: UIView!
    @IBOutlet weak var containerViewHand: UIView!
    @IBOutlet weak var containerViewDiscard: UIView!
    @IBOutlet weak var containerViewInPlay: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let temp = game["players"]
        if (temp != nil) {
            let relation = temp as! PFRelation
            let query = relation.query()
            var result = [PFObject]()
            do {
                result = try query.findObjects()
                
            } catch {
                print(error)
            }
            for obj in result {
                playerArray.append(obj as! PFUser)
            }
        }
        _ = self.navigationController?.popToRootViewController(animated: false)
        self.navigationController?.pushViewController(self as UIViewController, animated: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = game.value(forKey: "name") as! String?
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

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "messageBoardSegue") {
            let messageBoard = segue.destination as! MessageBoardViewController;
            messageBoard.gameId = game.value(forKey: "objectId") as! String
        } else if (segue.identifier == "gameViewSegue") {
            let vc = segue.destination as! GameViewController;
            vc.game = game
            vc.deckTypeKey = "lastPlayed"
        } else if (segue.identifier == "handViewSegue") {
            let vc = segue.destination as! HandViewController;
            let playerNum = HandViewController.getPlayerHandNum(game: game)
            let deckTypeKey = "player\(playerNum.description)Hand"
            vc.deckTypeKey = deckTypeKey

            vc.game = game
        } else if (segue.identifier == "discardViewSegue") {
            let vc = segue.destination as! DiscardViewController;
            vc.game = game
            vc.deckTypeKey = "discard"
            //vc.deck = game["discard"] as! PFObject
        } else if (segue.identifier == "inPlayViewSegue") {
            let vc = segue.destination as! InPlayViewController;
            vc.game = game
            vc.deckTypeKey = "inPlay"
            //vc.deck = game["inPlay"] as! PFObject
        }
    }
}
