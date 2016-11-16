//
//  Game.swift
//  1000 Cards
//
//  Created by Brian Shiau on 11/3/16.
//  Copyright © 2016 Isaac Garza. All rights reserved.
//

import UIKit

class Game: NSObject {
    var players:[String]
    var points:[Int]
    
    var played:[String]
    var discard:[String]
    var inPlayOn1:[String]
    var inPlayOn2:[String]
    var inPlayOn3:[String]
    var inPlayOn4:[String]
    var hand:[String]
    var deck: [String]
    
    // MARK: Initialization
    
    init(players: [String], theDeck: PFObject) {
        self.players = players
        self.points = [0,0,0,0]
        
        //played is the vector of cards that are played "in general" (ie new rules, etc)
        self.played = []
        self.discard = []
        self.inPlayOn1 = []
        self.inPlayOn2 = []
        self.inPlayOn3 = []
        self.inPlayOn4 = []
        self.hand = []
        self.deck = []
        let tempDeck: [String] = theDeck.object(forKey: "cards") as! [String]
        
        for i in tempDeck
        {
            self.deck.append(i)
        }
        
    }
}
