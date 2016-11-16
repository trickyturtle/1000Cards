//
//  Images.swift
//  SwiftParseChat
//
//  Created by Jesse Hu on 3/2/15.
//  Copyright (c) 2015 Jesse Hu. All rights reserved.
//

import Foundation

class Images {
    
    class func squareImage(_ image: UIImage, size: CGFloat) -> UIImage? {
        var cropped: UIImage!
        if (image.size.height > image.size.width)
        {
            let ypos = (image.size.height - image.size.width) / 2
            cropped = self.cropImage(image, x: 0, y: ypos, width: image.size.width, height: image.size.height)
        }
        else
        {
            let xpos = (image.size.width - image.size.height) / 2
            cropped = self.cropImage(image, x: xpos, y: 0, width: image.size.width, height: image.size.height)
        }
        
        let resized = self.resizeImage(cropped, width: size, height: size)

        return resized
    }
    
    class func resizeImage(_ image: UIImage, width: CGFloat, height: CGFloat) -> UIImage? {
        var image = image
        let size = CGSize(width: width, height: height)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        image.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
    
    class func cropImage(_ image: UIImage, x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat) -> UIImage? {
        let rect = CGRect(x: x, y: y, width: width, height: height)

        let imageRef = image.cgImage?.cropping(to: rect)
        let cropped = UIImage(cgImage: imageRef!)

        return cropped
    }
}
