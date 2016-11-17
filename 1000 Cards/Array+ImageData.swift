//
//  Array+ImageData.swift
//  1000 Cards
//
//  Created by David Alexander on 11/16/16.
//  Copyright © 2016 Isaac Garza. All rights reserved.
//

import UIKit

typealias ImageArray = [UIImage]
typealias ImageArrayRepresentation = Data

extension Array where Element: UIImage {
    // Given an array of UIImages return a Data representation of the array suitable for storing in core data as binary data that allows external storage
    func coreDataRepresentation() -> ImageArrayRepresentation? {
        let CDataArray = NSMutableArray()
        
        for img in self {
            guard let imageRepresentation = UIImagePNGRepresentation(img) else {
                print("Unable to represent image as PNG")
                return nil
            }
            let data : NSData = NSData(data: imageRepresentation)
            CDataArray.add(data)
        }
        
        return NSKeyedArchiver.archivedData(withRootObject: CDataArray)
    }
}

extension ImageArrayRepresentation {
    // Given a Data representation of an array of UIImages return the array
    func imageArray() -> ImageArray? {
        if let mySavedData = NSKeyedUnarchiver.unarchiveObject(with: self) as? NSArray {
            // TODO: Use regular map and return nil if something can't be turned into a UIImage
            let imgArray = mySavedData.flatMap({
                return UIImage(data: $0 as! Data)
            })
            return imgArray
        }
        else {
            print("Unable to convert data to ImageArray")
            return nil
        }
    }
}
