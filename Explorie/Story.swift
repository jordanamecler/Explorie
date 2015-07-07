//
//  Story.swift
//  Explorie
//
//  Created by Lorenzo Saraiva on 5/19/15.
//  Copyright (c) 2015 BEPID-PucRJ. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class Story:NSObject {
    
    struct Counter{
        static var totalStories = 0
    }
    
    var photo:UIImage?
    var text:String!
    var title:String!
    var id:String!
    var type:String!
    var creator:String!
    var likedBy = [String]()
    var local:CLLocationCoordinate2D!
    
    override var description: String {
        return "id: \(id)" +
        "type: \(type)"
    }
    
    init(storyPhoto:UIImage, storyTitle:String, storyText:String, storyType:String, storyLocal:CLLocationCoordinate2D, storyCreator:String){
        
        super.init()
        photo = storyPhoto
        text = storyText
        type = storyType
        local = storyLocal
        title = storyTitle
        creator = storyCreator
    }
    
    func getStoryId() -> String {
        return id
    }
    
    
    func parseStory() -> Dictionary<String,String> {
        
        
        let base64String = UIImage.convertImageToBase64(photo!)
        var likedByString = String()
        
        for each in likedBy{
            
            
            likedByString += each
            likedByString += ","
        }
        return ["storyText":"\(text)", "storyType":"\(type)","storyID":"\(id)","imageData":base64String,"latitude":"\(local.latitude)","longitude":"\(local.longitude)","storyTitle":"\(title)","creator":"\(creator)","likedBy":likedByString]
        
    }
}