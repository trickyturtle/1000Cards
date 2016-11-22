
//
//  CardListView.swift
//  1000 Cards
//
//  Created by David Alexander on 11/18/16.
//  Copyright © 2016 Isaac Garza. All rights reserved.
//
import Foundation
class CardCarouselView: UIViewController, iCarouselDataSource, iCarouselDelegate{
    
    var deckID = "Error"
    var deckArray = [String]()
    var deck = PFObject(className: "Deck")
    var cardImages = [UIImage]()
//    var currentGameID: String = "Game Object Init Error"
//    var currentGame: PFObject = PFObject(className: "Game")
    var cardData = PFObject(className: "Card")
    var carousel: iCarousel!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        carousel.type = .coverFlow2
        NotificationCenter.default.addObserver(self, selector: #selector(CardCarouselView.addedCard( _:)), name:NSNotification.Name(rawValue: "addedCard"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(CardCarouselView.removedCard( _:)), name:NSNotification.Name(rawValue: "removedCard"), object: nil)

    }
    
    func numberOfItems(in carousel: iCarousel) -> Int {
        if (deckArray.count == 0) {
            let temp = deck["cards"]
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
                deckID = deck.objectId!
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
            destination.deck = deck
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
        deckArray.append(userInfo!["newCard"]!)
        cardImages.append(CardReader.getImage(parseID: userInfo!["newCard"]! )!)
        carousel.reloadData()
    }
    
    func removedCard(_ notification: Notification) {
        let userInfo = notification.userInfo as? Dictionary<String, Int>
        deckArray.remove(at: (userInfo?["index"])!)
        cardImages.remove(at: (userInfo?["index"])!)
        carousel.reloadData()
    }
}
