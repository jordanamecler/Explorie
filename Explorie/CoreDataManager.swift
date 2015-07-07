//
//  CoreDataManager.swift
//  Explorie
//
//  Created by Lorenzo Saraiva on 5/22/15.
//  Copyright (c) 2015 BEPID-PucRJ. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation

class CoreDataManager: NSObject {
    
    var stories = [NSManagedObject]()
    class var sharedInstance: CoreDataManager {
        
        struct Singleton {
            
            static let instance = CoreDataManager()
        }
        return Singleton.instance
    }
    
    func saveStories(allStories: Array<Story>) {
        
        var tempStory:Story!
        stories.removeAll(keepCapacity: false)
        for (var i = 0; i<allStories.count; i++){
            
            println("Saving Loop")
            
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            
            let managedContext = appDelegate.managedObjectContext!
            
            let entity =  NSEntityDescription.entityForName("Story",inManagedObjectContext: managedContext)
            
            let storedStory = NSManagedObject(entity: entity!, insertIntoManagedObjectContext:managedContext)
            
            tempStory = allStories[i]
            
            
            
            let base64String = UIImage.convertImageToBase64(tempStory.photo!)
            
            storedStory.setValue("\(tempStory.text)", forKey: "text")
            storedStory.setValue("\(tempStory.title)", forKey: "title")
            storedStory.setValue("\(tempStory.id)", forKey: "id")
            storedStory.setValue("\(tempStory.type)", forKey: "type")
            storedStory.setValue("\(tempStory.local.latitude)", forKey: "latitude")
            storedStory.setValue("\(tempStory.local.longitude)", forKey: "longitude")
            storedStory.setValue(base64String, forKey: "photo")
            storedStory.setValue("\(tempStory.creator)", forKey: "creator")
            storedStory.setValue("\(tempStory.likedBy.description)", forKey: "likedBy")

            var error: NSError?
            if !managedContext.save(&error) {
                println("Could not save \(error), \(error?.userInfo)")
            }
            
            stories.append(storedStory)
        }
    }
    
    
    func fetchStories(){
        
        let appDelegate =
        UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext!
        
        let fetchRequest = NSFetchRequest(entityName:"Story")
        
        var error: NSError?
        
        let fetchedResults =
        managedContext.executeFetchRequest(fetchRequest,
            error: &error) as? [NSManagedObject]
        
        if let results = fetchedResults {
            stories = results
            
        } else {
            println("Could not fetch \(error), \(error!.userInfo)")
        }
        
    }
    
    func fetchUser(){
        
        let appDelegate =
        UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext!
        
        let fetchRequest = NSFetchRequest(entityName:"User")
        
        var error: NSError?
        
        let fetchedResults =
        managedContext.executeFetchRequest(fetchRequest,
            error: &error) as? [NSManagedObject]
        
        if let results = fetchedResults {
            stories = results
            
        } else {
            println("Could not fetch \(error), \(error!.userInfo)")
        }
        
    }

    
    func deleteStories(){
        
        var bas: NSManagedObject!
        
        for bas: AnyObject in stories
        {
            (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext!.deleteObject(bas as! NSManagedObject)
        }
        
        stories.removeAll(keepCapacity: false)
    }
    
    func unsparseStories() -> Array<Story>{
        var storyArray = [Story]()
        NSLog("Unparsed Called")
        
        var newStory:Story!
        for (var i = 0; i<stories.count; i++){
            
            NSLog("looop")
            
            var parsedStory = stories[i]
            let image = UIImage.convertBase64ToImage(parsedStory.valueForKey("photo") as! String)
            
            newStory = Story(storyPhoto:image,storyTitle: parsedStory.valueForKey("title") as! String, storyText: parsedStory.valueForKey("text") as! String, storyType: parsedStory.valueForKey("type") as! String, storyLocal: CLLocationCoordinate2DMake((parsedStory.valueForKey("latitude") as! NSString).doubleValue, (parsedStory.valueForKey("longitude") as! NSString).doubleValue),storyCreator:parsedStory.valueForKey("creator")  as! String
            )
            
            var tempString = parsedStory.valueForKey("likedBy") as! NSString
            if (tempString == "[]"){
                tempString = ""
            }else{
                tempString = tempString.substringFromIndex(1)
                tempString = tempString.substringToIndex(tempString.length - 2)
            }
            var tempArray = tempString.componentsSeparatedByString(",") as Array
            
            newStory.likedBy = tempArray as! Array<String>
            newStory.id = parsedStory.valueForKey("id") as! String
            
            storyArray.append(newStory)
        }
        
        deleteStories()
        return storyArray
    }
    
    
}