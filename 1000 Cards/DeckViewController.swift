//
//  ViewController.swift
//  1000 Cards
//
//  Created by Isaac Garza on 10/11/16.
//  Copyright © 2016 Isaac Garza. All rights reserved.
//

import UIKit


class DeckViewController: CardCarouselView
{
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if deck["title"] == nil{
            let vc : DeckInfoView = self.storyboard!.instantiateViewController(withIdentifier: "deckInfo") as! DeckInfoView
            vc.deck = deck
            self.navigationController?.pushViewController(vc as UIViewController, animated: true)
        } else {
            self.title = deck["title"] as? String
        }
    }
    
    
//    @IBAction func removeFromDeck(_ sender: Any) {
//        
//    }
}
