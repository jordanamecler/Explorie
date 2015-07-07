//
//  Extensions.swift
//  sidesApp
//
//  Created by Haroldo Olivieri on 5/20/15.
//  Copyright (c) 2015 Haroldo Olivieri. All rights reserved.
//

import Foundation
import UIKit

extension UIImage{
    
    // convert UIImage into base64 and keep them into string
    class func convertImageToBase64(image: UIImage) -> String {
            
        var imageData = UIImageJPEGRepresentation(image, 0.01)
        let base64String = imageData.base64EncodedStringWithOptions(.allZeros)
        return base64String
        
    }
    
    // convert base64 into UIImage
    class func convertBase64ToImage(base64String: String) -> UIImage {
        
        let decodedData = NSData(base64EncodedString: base64String, options: NSDataBase64DecodingOptions(rawValue: 0) )
        
        var decodedimage = UIImage(data: decodedData!)
        
        return decodedimage!
        
    }
}

extension NSData{
    
    // convert files into base64 and keep them into string
    class func convertFiletoBase64(path : String) -> String{
        let fileData : NSData = NSData(contentsOfFile: path, options: NSDataReadingOptions.DataReadingMappedIfSafe, error: nil)!
        
        return fileData.base64EncodedStringWithOptions(.allZeros)
    }
    
    // convert base64 to a file path with the data storaged
    class func convertBase64ToFilePath(base64String : String) -> String{
        
        let decodedData = NSData(base64EncodedString: base64String, options: NSDataBase64DecodingOptions(rawValue: 0))
        
        var videoFile : NSData = NSData(data: decodedData!);
        
        let documentsPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! NSString
        
        var path : String = (documentsPath as String) + "/myMovie.mov";
        videoFile.writeToFile(path, atomically: true);
        
        return path;
    }
}