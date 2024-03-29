//
//  CardReader.swift
//  1000 Cards
//
//  Created by David Alexander on 11/17/16.
//  Copyright © 2016 Isaac Garza. All rights reserved.
//
import Foundation
import UIKit


//let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
class CardReader{
    
    //    let coreDataObject = cards.coreDataRepresentation()
    //
    //    if let retrievedImgArray = coreDataObject?.imageArray() {
    //        // use retrievedImgArray
    //    }
    //    func storeImage(image: UIImage, parseID: String){
    
    //        //convert image to jpeg
    //        var jpgData: Data = UIImageJPEGRepresentation(image, 0.5)!;
    //
    //        var paths: NSArray = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) as NSArray
    //        //add the file name to the path
    //        let filePath: NString = [documentsPath: stringByAppendingPathComponent:@"\(parseID)"]; //Add the file name
    //        [pngData writeToFile:filePath atomically:YES]; //Write the file
    //
    //
    //        NSData *pngData = [NSData dataWithContentsOfFile:filePath];
    //        UIImage *image = [UIImage imageWithData:pngData];
    
    //        if let data = UIImageJPEGRepresentation(image, 0.8) {
    //            let filename = getDocumentsDirectory().appendingPathComponent("copy.png")
    //            try? data.write(to: filename)
    //        }
    //
    //    }
    
    //    - (NSString *)documentsPathForFileName:(NSString *)name
    //    {
    //    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    //    NSString *documentsPath = [paths objectAtIndex:0];
    //
    //    return [documentsPath stringByAppendingPathComponent:name];
    //    }
    
    static func imageToParseFile(image: UIImage, title: String) -> PFFile {
        let data = UIImagePNGRepresentation(image)
        let file = PFFile(name: title, data: data!)
        return file!
    }
    
    static func convertDataToImage(data: Data) ->UIImage{
        let image : UIImage = UIImage(data: data)!
        return image
    }
    
    static func saveImageToDocumentDirectory(image: UIImage, parseID: String){
        let fileManager = FileManager.default
        let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent("\(parseID)")
        //let image = UIImage(named: "apple.jpg")
        print(paths)
        let imageData = UIImageJPEGRepresentation(image, 0.2)
        fileManager.createFile(atPath: paths as String, contents: imageData, attributes: nil)
    }
    
    //returns DD as URL
    static func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    //returns DD as String
    static func getDirectoryPath() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    static func getImage(parseID: String)->UIImage?{
        let fileManager = FileManager.default
        let imagePAth = (self.getDirectoryPath() as NSString).appendingPathComponent("\(parseID)")
        if fileManager.fileExists(atPath: imagePAth){
            return UIImage(contentsOfFile: imagePAth)!
        }else{
            print("No Image")
            return nil
        }
    }
    
    static func getCardTitle(parseID: String)->String{
        var cardTitle:String = "CardTitle Error"

        do {cardTitle = try (PFQuery.getObjectOfClass("Card", objectId: parseID).object(forKey: "title") as! String?)!
        }catch {
            // If an error occurs
            let nserror = error as NSError
            NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
            abort()
        }
        return cardTitle
    }
    
}
