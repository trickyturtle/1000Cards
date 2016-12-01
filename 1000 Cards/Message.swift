//
//  Message.swift
//  1000 Cards
//
//  Created by Isaac Garza on 11/15/16.
//  Copyright © 2016 Isaac Garza. All rights reserved.
//

import Foundation
import UIKit
class Message: NSObject {
    
    private(set) var senderId = ""
    private(set) var senderDisplayName = ""
    private(set) var date: Date!
    private(set) var isMediaMessage = false
    private(set) var text = ""
    //private(set) weak var media: JSQMessageMediaData?
    
    // MARK: - Initialization

    override init() {}
    
    init(senderId: String, displayName: String, text: String) {
        self.senderId = senderId
        self.senderDisplayName = displayName
        self.text = text
    }
    
    init(senderId: String, displayName: String, date: Date, text: String) {
        self.senderId = senderId
        self.senderDisplayName = displayName
        self.text = text
        self.date = date
    }
}
