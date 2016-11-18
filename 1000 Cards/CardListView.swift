//
//  CardListView.swift
//  1000 Cards
//
//  Created by David Alexander on 11/18/16.
//  Copyright © 2016 Isaac Garza. All rights reserved.
//

import Foundation
class CardListView: UIViewController, iCarouselDataSource, iCarouselDelegate{
    
    var cards = [UIImage]()
    var currentGameID: String = "Game Object Init Error"
    var currentGame: PFObject = PFObject(className: "Game")
    var cardList: [String] = []
    var cardData = PFObject(className: "Card")
    @IBOutlet var carousel: iCarousel!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        
        
        for cardKey in currentGame.object(forKey: dictKey) as! NSArray
        {
            //TODO: this should probably be a view object rather than an image...if possible
            cardList.append(cardKey as! String)
            cards.append(CardReader.getImage(parseID: cardKey as! String)!)
        }
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        //Get Game info
        carousel.type = .coverFlow2
        currentGameID = GameAction.getCurrentGame()
        do {try currentGame = PFQuery.getObjectOfClass("Game", objectId: currentGameID)
        }catch {
            // If an error occurs
            let nserror = error as NSError
            NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
            abort()
        }
    }
    
    func numberOfItems(in carousel: iCarousel) -> Int
    {
        return cards.count
    }
    
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView
    {
        var label: UILabel
        var itemView: UIImageView
        
        //create new view if no view is available for recycling
        if (view == nil)
        {
            //don't do anything specific to the index within
            //this `if (view == nil) {...}` statement because the view will be
            //recycled and used with other index values later
            itemView = UIImageView(frame:CGRect(x:0, y:0, width:200, height:200))
            itemView.image = UIImage(named: "damnapes.jpg")
            itemView.contentMode = .center
            
            label = UILabel(frame:itemView.bounds)
            label.backgroundColor = UIColor.clear
            label.textAlignment = .center
            label.tag = 1
            label.contentMode = .top
            itemView.addSubview(label)
        }
        else
        {
            //get a reference to the label in the recycled view
            itemView = view as! UIImageView;
            label = itemView.viewWithTag(1) as! UILabel!
        }
        
        //set item label
        //remember to always set any properties of your carousel item
        //views outside of the `if (view == nil) {...}` check otherwise
        //you'll get weird issues with carousel item content appearing
        //in the wrong place in the carousel
        do{
            try label.text = PFQuery.getObjectOfClass("Card", objectId: cardList[index]).object(forKey: "title") as! String?
        }catch{
            // If an error occurs
            let nserror = error as NSError
            NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
            abort()
        }
        
        return itemView
    }
    
    func carousel(_ carousel: iCarousel, valueFor option: iCarouselOption, withDefault value: CGFloat) -> CGFloat
    {
        if (option == .spacing)
        {
            return value * 1.1
        }
        return value
    }
    
    func carousel(_ carousel: iCarousel, didSelectItemAt index: Int) {
        let vc : AnyObject! = self.storyboard!.instantiateViewController(withIdentifier: "cardViewController")
        do{
            try cardData = PFQuery.getObjectOfClass("Card", objectId: cardList[index])
            
        }catch{
            // If an error occurs
            let nserror = error as NSError
            NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
            abort()
        }
        self.navigationController?.pushViewController(vc as! UIViewController, animated: true)
    }
    
    func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if  segue.identifier == "cardViewController",
            let destination = segue.destination as? CardView
        {
            destination.card = cardData
        }
    }
    

}
