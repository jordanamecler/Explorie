//
//  PersistencyManager.swift
//  Explorie
//
//  Created by Lorenzo Saraiva on 5/19/15.
//  Copyright (c) 2015 BEPID-PucRJ. All rights reserved.
//

import UIKit
import CoreLocation

class StoryDAO: NSObject {
    
    private var stories = [Story]()
    
    var storyRef = Firebase(url:"https://sizzling-inferno-6992.firebaseio.com/allStories")
    
    
    override init() {
        
        super.init()
        var connectionCheck = Reachability()
        
        if (!connectionCheck.isConnectedToNetwork()){
            
        }
        else{
            //            self.stories.removeAll(keepCapacity: false)
            synchronizeWithCoreData()
            updateDeletedStories()
            self.synchronizeWithFirebase()
        }
    }
    
    func synchronizeWithCoreData(){
        
        CoreDataManager.sharedInstance.fetchStories()
        stories = CoreDataManager.sharedInstance.unsparseStories()
        
    }
    
    func updateDeletedStories(){
        var counter = 0
        for story in self.stories {
            let updateRef = self.storyRef.childByAppendingPath("\(story.id)")
            
            updateRef.observeSingleEventOfType(.Value, withBlock: { snapshot in
                if snapshot.value is NSNull {
                    self.stories.removeAtIndex(counter)
                    println("deletada!")
                }else{
                    
                    counter++
                }
            })
            
        }
        
    }
    func synchronizeWithFirebase(){
        println("SYNC CALLED")
        var counter = 0
        storyRef.observeSingleEventOfType(.Value, withBlock: { snapshot in
            println("Tem \(snapshot.childrenCount) no Firebase")
            for rest in snapshot.children.allObjects as! [FDataSnapshot] {
                
                
                if (self.stories.count > counter){
                    if (self.stories[counter].id != rest.value.objectForKey("storyID") as? String){
                        self.getStory(rest)
                        
                    }else{
                        println("Historia ja existe!!")
                    }
                }else{
                    self.getStory(rest)
                }
                counter++
            }
        })
    }
    
    func getStories() -> [Story]
    {
        println("The are \(stories.count) stories")
        return stories
    }
    
    func getStory(rest:FDataSnapshot){
        
        let data: AnyObject? = rest.value.objectForKey("imageData")
        let image = UIImage.convertBase64ToImage(data as! String)
        var newStory = Story(storyPhoto:image,
            storyTitle:rest.value.objectForKey("storyTitle") as! String,
            storyText: rest.value.objectForKey("storyText") as! String,
            storyType: rest.value.objectForKey("storyType") as! String,
            storyLocal:CLLocationCoordinate2DMake((rest.value.objectForKey("latitude") as! NSString).doubleValue,(rest.value.objectForKey("longitude") as! NSString).doubleValue),
            storyCreator:rest.value.objectForKey("creator") as! String)
        newStory.id = rest.value.objectForKey("storyID") as! String
        var tempString = rest.value.objectForKey("likedBy") as! NSString
        if (tempString.length == 0||tempString == "[]"){
            tempString = ""
        }else{
            tempString = tempString.substringFromIndex(1)
            tempString = tempString.substringToIndex(tempString.length - 1)
        }
        tempString = tempString.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        var tempArray = tempString.componentsSeparatedByString(",") as Array
        newStory.likedBy = tempArray as! Array<String>
        let text: AnyObject? = rest.value.objectForKey("storyText")
        println("\(text)")
        self.stories.append(newStory)
        
        
    }
    func updateStory(story:Story)
    {
        let updateRef = storyRef.childByAppendingPath("\(story.id)")
        
        updateRef.observeSingleEventOfType(.Value, withBlock: { snapshot in
            if snapshot.value is NSNull {
                return
            }else{
                var temp = ["likedBy":"\(story.likedBy.description)"]
                updateRef.updateChildValues(temp)
            }
        })
        
    }
    
    
    
    
    
    func addStory(story: Story) -> Bool {
        
        
        var allStories = [Dictionary<String,String>]()
        
        stories.append(story)
        
        println("The are \(stories.count) stories after adding")
        
        
        let newStoryRef = storyRef.childByAutoId()
        
        story.id = newStoryRef.key
        
        var tempStory = story.parseStory()
        var isSaved:Bool?
        
        newStoryRef.setValue(tempStory, withCompletionBlock: {
            (error:NSError?, ref:Firebase!) in
            if (error != nil) {
                println("Data could not be saved.")
            } else {
                println("Data saved successfully!")
            }
        })
        return true
    }
    
    func getRandomStory() -> Story{
        var randomIndex = Int(arc4random_uniform(UInt32(stories.count)))
        return stories[randomIndex]
    }
    
    func deleteStory(story: Story) {
        
        let removeRef = storyRef.childByAppendingPath("\(story.id)")
        removeRef.removeValue()
        var tempStory:Story!
        for (var i = 0; i < stories.count; i++){
            tempStory = stories[i]
            if (tempStory.isEqual(story)){
                stories.removeAtIndex(i)
                break
            }
        }
    }
}
