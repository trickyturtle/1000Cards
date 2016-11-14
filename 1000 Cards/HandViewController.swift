//
//  HandViewController.swift
//  1000 Cards
//
//  Created by Brian Shiau on 10/31/16.
//  Copyright © 2016 Isaac Garza. All rights reserved.
//

import Foundation
import UIKit

class HandViewController: UIViewController, iCarouselDataSource, iCarouselDelegate
{
    var items: [Int] = []
    var cardData = PFObject(className: "Card")
    @IBOutlet var carousel: iCarousel!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        for i in 0...10
        {
            items.append(i)
        }
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        carousel.type = .coverFlow2
    }
    
    func numberOfItems(in carousel: iCarousel) -> Int
    {
        return items.count
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
        label.text = "\(items[index])"
        
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
        cardData = items[index] as! PFObject
        self.navigationController?.pushViewController(vc as! UIViewController, animated: true)
    }
    
    func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
       
        if  segue.identifier == "cardViewController",
            let destination = segue.destination as? CardView
        {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let managedContext = appDelegate.managedObjectContext
            
            //let fetchRequest = NSFetchRequest(entityName: "Card")
            //var fetchedResults:[NSManagedObject]
//            
//            do {
//                try fetchedResults = managedContext.executeFetchRequest(fetchRequest) as! [NSManagedObject]
//                
//            }catch {
//                // If an error occurs
//                let nserror = error as NSError
//                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
//                abort()
//            }
        
            destination.card = cardData
        }
    }
    

}
