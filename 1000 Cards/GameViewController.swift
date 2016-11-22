//
//  GameViewController.swift
//  1000 Cards
//
//  Created by Brian Shiau on 10/31/16.
//  Copyright © 2016 Isaac Garza. All rights reserved.
//

import Foundation
import UIKit

class GameViewController: GameCardCarouselView
{
    var playerArray:[PFUser] = []
    @IBOutlet weak var player1Name: UILabel!
    @IBOutlet weak var player2Name: UILabel!
    @IBOutlet weak var player3Name: UILabel!
    @IBOutlet weak var player4Name: UILabel!
    @IBOutlet weak var player1Score: UILabel!
    @IBOutlet weak var player2Score: UILabel!
    @IBOutlet weak var player3Score: UILabel!
    @IBOutlet weak var player4Score: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        let temp = game["players"]
//        if (temp != nil) {
//            let relation = temp as! PFRelation
//            let query = relation.query()
//            var result = [PFObject]()
//            do {
//                result = try query.findObjects()
//                
//            } catch {
//                print(error)
//            }
//            for obj in result {
//                playerArray.append(obj as! PFUser)
//            }
        
        
        var numPlayers = playerArray.count
        var tempIndex = 0
        let playerLabelArray = [player1Name, player2Name, player3Name, player4Name]
        let playerScoreLabelArray = [player1Score, player2Score, player3Score, player4Score]
        while(numPlayers > 0){
            playerLabelArray[tempIndex]?.text = playerArray[tempIndex].username

            numPlayers -= 1
            tempIndex += 1
            playerScoreLabelArray[tempIndex]?.text = game["player\(tempIndex)Score"] as! String?
        }
        while (tempIndex < 4){
            playerLabelArray[tempIndex]?.isHidden = true
            playerScoreLabelArray[tempIndex]?.isHidden = true
            tempIndex += 1
        }
    }
}

    

