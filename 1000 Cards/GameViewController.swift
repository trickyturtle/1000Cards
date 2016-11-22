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
    
    override func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        var uiView: UIView
        var label: UILabel
        var imageView: UIImageView
        
        //create new view if no view is available for recycling
        if (view == nil) {
            //don't do anything specific to the index within
            //this `if (view == nil) {...}` statement because the view will be
            //recycled and used with other index values later
            uiView = UIView(frame: CGRect(x:0, y:20, width:200, height:350))
            
            imageView = UIImageView(frame:CGRect(x:0, y:25, width:200, height:180))
            imageView.contentMode = .scaleAspectFit
            imageView.clipsToBounds = true
            imageView.image = cardImages[index]
            imageView.tag = 0
            
            label = UILabel(frame: CGRect(x:0, y:0, width:200, height:20))
            label.backgroundColor = UIColor.clear
            label.textColor = UIColor.white
            label.textAlignment = .center
            label.tag = 1
            label.contentMode = .bottom
            uiView.addSubview(imageView)
            uiView.addSubview(label)
            
        } else {
            //get a reference to the label in the recycled view
            uiView = view! as UIView
            imageView = uiView.viewWithTag(0) as! UIImageView!
            label = uiView.viewWithTag(1) as! UILabel!
        }
        
        //set item label
        //remember to always set any properties of your carousel item
        //views outside of the `if (view == nil) {...}` check otherwise
        //you'll get weird issues with carousel item content appearing
        //in the wrong place in the carousel
        do{
            try label.text = PFQuery.getObjectOfClass("Card", objectId: deckArray[index] ).object(forKey: "title") as! String?
        } catch {
            // If an error occurs
            let nserror = error as NSError
            NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
            abort()
        }
        
        return uiView
    }
}

    

