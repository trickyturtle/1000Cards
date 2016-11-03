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
    
    //var played:[Card]
    //var discard:[Card]
    //var inPlay:[Card]
    //var hand:[Card]
    
    // MARK: Initialization
    
    init(players: [String], points: [Int]) {
        self.players = players
        self.points = points
    }
}
