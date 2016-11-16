//
//  Messages.swift
//  SwiftParseChat
//
//  Created by Jesse Hu on 2/21/15.
//  Copyright (c) 2015 Jesse Hu. All rights reserved.
//

import Foundation
import Parse

class Messages {
    
    class func createMessageItem(_ user: PFUser, groupId: String, description: String) {
        let query = PFQuery(className: PF_MESSAGES_CLASS_NAME)
        query.whereKey(PF_MESSAGES_USER, equalTo: user)
        query.whereKey(PF_MESSAGES_GROUPID, equalTo: groupId)
        query.findObjectsInBackground(block: { (objects: [PFObject]?, error: Error?) in
            if error == nil {
                if objects!.count == 0 {
                    let message = PFObject(className: PF_MESSAGES_CLASS_NAME)
                    message[PF_MESSAGES_USER] = user;
                    message[PF_MESSAGES_GROUPID] = groupId;
                    message[PF_MESSAGES_DESCRIPTION] = description;
                    message[PF_MESSAGES_LASTUSER] = PFUser.current()
                    message[PF_MESSAGES_LASTMESSAGE] = "";
                    message[PF_MESSAGES_COUNTER] = 0
                    message[PF_MESSAGES_UPDATEDACTION] = NSDate()
                    message.saveInBackground(block: { (succeeded: Bool, error: Error?) -> Void in
                        if (error != nil) {
                            print("Messages.createMessageItem save error.")
                            print(error ?? "")
                        }
                    })
                }
            } else {
                print("Messages.createMessageItem save error.")
                print(error ?? "")
            }

        })
    }
    
    class func deleteMessageItem(_ message: PFObject) {
        message.deleteInBackground { (succeeded: Bool, error: Error?) -> Void in
            if error != nil {
                print("UpdateMessageCounter save error.")
                print(error ?? "")
            }
        }
    }
    
    class func updateMessageCounter(_ groupId: String, lastMessage: String) {
        let query = PFQuery(className: PF_MESSAGES_CLASS_NAME)
        query.whereKey(PF_MESSAGES_GROUPID, equalTo: groupId)
        query.limit = 1000
        query.findObjectsInBackground { (objects: [PFObject]?, error: Error?) -> Void in
            if error == nil {
                for message in objects as [PFObject]! {
                    let user = message[PF_MESSAGES_USER] as! PFUser
                    if user.objectId != PFUser.current()!.objectId {
                        message.incrementKey(PF_MESSAGES_COUNTER) // Increment by 1
                        message[PF_MESSAGES_LASTUSER] = PFUser.current()
                        message[PF_MESSAGES_LASTMESSAGE] = lastMessage
                        message[PF_MESSAGES_UPDATEDACTION] = NSDate()
                        message.saveInBackground(block: { (succeeded: Bool, error: Error?) -> Void in
                            if error != nil {
                                print("UpdateMessageCounter save error.")
                                print(error ?? "")
                            }
                        })
                    }
                }
            } else {
                print("UpdateMessageCounter save error.")
                print(error ?? "")
            }
        }
    }
    
    class func clearMessageCounter(_ groupId: String) {
        let query = PFQuery(className: PF_MESSAGES_CLASS_NAME)
        query.whereKey(PF_MESSAGES_GROUPID, equalTo: groupId)
        query.whereKey(PF_MESSAGES_USER, equalTo: PFUser.current()!)
        query.findObjectsInBackground { (objects: [PFObject]?, error: Error?) -> Void in
            if error == nil {
                for message in objects as [PFObject]! {
                    message[PF_MESSAGES_COUNTER] = 0
                    message.saveInBackground(block: { (succeeded: Bool, error: Error?) -> Void in
                        if error != nil {
                            print("ClearMessageCounter save error.")
                            print(error ?? "")
                        }
                    })
                }
            } else {
                print("ClearMessageCounter save error.")
                print(error ?? "")
            }
        }
    }

}
