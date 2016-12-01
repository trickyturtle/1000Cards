//
//  GameCardCarouselView.swift
//  1000 Cards
//
//  Created by Isaac Garza on 11/22/16.
//  Copyright © 2016 Isaac Garza. All rights reserved.
//

import Foundation

class GameCardCarouselView: UIViewController, iCarouselDataSource, iCarouselDelegate{
    
    var deckArray = [String]()
    var game = PFObject(className: "Game")
    var cardImages = [UIImage]()
    var cardData = PFObject(className: "Card")
    var carousel: iCarousel!
    var handArray = [String]()
    var inPlayArray = [String]()
    var discardArray = [String]()
    var actionArray:[String] = []
    var deckTypeKey = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        carousel.type = .coverFlow2
        NotificationCenter.default.addObserver(self, selector: #selector(GameCardCarouselView.addedCard( _:)), name:NSNotification.Name(rawValue: "addedCard"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(GameCardCarouselView.removedCard( _:)), name:NSNotification.Name(rawValue: "removedCard"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(GameCardCarouselView.playedCard( _:)), name:NSNotification.Name(rawValue: "playededCard"), object: nil)
    }
    
    func numberOfItems(in carousel: iCarousel) -> Int {
        if (deckArray.count == 0) {
            let temp = game[deckTypeKey]
            print(deckTypeKey)
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
                    deckArray.append(obj.objectId! )
                }
                for cardKey in deckArray {
                    //TODO: this should probably be a view object rather than an image...if possible
                    cardImages.append(CardReader.getImage(parseID: cardKey )!)
                }
            }
        }
        return deckArray.count
    }
    
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
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
            //TODO: add check if we are in gameView, and if so get GameAction messages
            try label.text = PFQuery.getObjectOfClass("Card", objectId: deckArray[index] ).object(forKey: "title") as! String?
        } catch {
            // If an error occurs
            let nserror = error as NSError
            NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
            abort()
        }
        
        return uiView
    }
    
    func carousel(_ carousel: iCarousel, valueFor option: iCarouselOption, withDefault value: CGFloat) -> CGFloat {
        if (option == .spacing) {
            return value * 1.1
        }
        return value
    }
    
    func carousel(_ carousel: iCarousel, didSelectItemAt index: Int) {
        let vc : CardView = self.storyboard!.instantiateViewController(withIdentifier: "cardViewController") as! CardView
        do{
            try cardData = PFQuery.getObjectOfClass("Card", objectId: deckArray[index])
            vc.card = cardData
            vc.cardImage = cardImages[index]
            vc.currIndex = index
            vc.isHand = true
        } catch{
            // If an error occurs
            let nserror = error as NSError
            NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
            abort()
        }
        self.navigationController?.pushViewController(vc as UIViewController, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "createNewCardSegue",
            let destination = segue.destination as? CreateNewCardView {
            destination.game = game
        }
        else if segue.identifier == "addFromCardLibrarySegue",
            let destination = segue.destination as? AllPrivateCardsView {
            do{
                try destination.deck = PFQuery.getObjectOfClass("Deck", objectId: PFUser.current()?.value(forKey: "allCardDeckId") as! String)
                
            } catch{
                // If an error occurs
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
            
        }
    }
    
    func addedCard(_ notification: Notification) {
        let userInfo = notification.userInfo as? Dictionary<String, String>
        //deckArray.append(userInfo!["newCard"]!)
        cardImages.append(CardReader.getImage(parseID: userInfo!["newCard"]! )!)
        let gameAction =  (GameAction.createActionMessage(player: PFUser.current()!.username!, source: "N/A", action: "N/A", dest: "deck"))
        GameAction.saveActionToGame(game: game, gameAction: gameAction)
        carousel.reloadData()
    }
    
    // TODO: Fix funciton
    func discardedCard(_ notification: Notification) {
        let userInfo = notification.userInfo as? Dictionary<String, PFObject>

        let gameAction =  (GameAction.createActionMessage(player: PFUser.current()!.username!, source: "inPlay", action: (userInfo?["removedCard"])!.objectId!, dest: "discard"))
        GameAction.saveActionToGame(game: game, gameAction: gameAction)
        carousel.reloadData()
    }
    
    func removedCard(_ notification: Notification) {
        let userInfo = notification.userInfo as? Dictionary<String, Int>
        deckArray.remove(at: (userInfo?["index"])!)
        cardImages.remove(at: (userInfo?["index"])!)
        carousel.reloadData()
    }
    
    func playedCard(_ notification: Notification) {
        let userInfo = notification.userInfo as? Dictionary<String, PFObject>
        let gameAction =  (GameAction.createActionMessage(player: PFUser.current()!.username!, source: "hand", action: (userInfo?["playedCard"])!.objectId!, dest: "inPlay"))
        GameAction.saveActionToGame(game: game, gameAction: gameAction)
        
        var relation = game.relation(forKey: deckTypeKey)
        relation.remove((userInfo?["playedCard"])!)
        relation = game.relation(forKey: "inPlay")
        relation.add((userInfo?["playedCard"])!)
        //TODO: this needs to happen more quickly, we need save() and error handling or an alert
        game.saveEventually()
                
        carousel.reloadData()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
