//
//  HandViewController.swift
//  1000 Cards
//
//  Created by Brian Shiau on 10/31/16.
//  Copyright © 2016 Isaac Garza. All rights reserved.
//
import Foundation
import UIKit





class HandViewController: GameCardCarouselView
{

    //TODO: add IBOutlet carousel    
    @IBAction func createNewCard(_ sender: Any) {
        let vc : CreateNewCardView = self.storyboard!.instantiateViewController(withIdentifier: "createCard") as! CreateNewCardView
        vc.game = game
        self.navigationController?.pushViewController(vc as UIViewController, animated: true)
    }
    
    @IBAction func drawCard(_ sender: Any) {
        //add card to current players hand
        
        
    }
    
    
}
