//
//  ExplorieViewController.swift
//  Explorie
//
//  Created by Jordana Mecler on 26/05/15.
//  Copyright (c) 2015 Explories. All rights reserved.
//

import UIKit

class SavedStoriesViewController: UIViewController, UIPageViewControllerDataSource
{
    
    var likedStories = [Story]()
    var tempArray = [Story]()
    var activeIndex = 0
    var type = 0
    
    var pageViewController: UIPageViewController!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(red: 255/255, green: 219/255, blue: 180/255, alpha: 1.0)

        getUserLikedStories()

        self.pageViewController = self.storyboard?.instantiateViewControllerWithIdentifier("PageViewController") as! UIPageViewController
        
        self.pageViewController.dataSource = self
        var startVC = self.viewControllerAtIndex(0) as ContentViewController
        
        var viewControllers = NSArray(object: startVC)
        
        self.pageViewController.setViewControllers(viewControllers as [AnyObject], direction: .Forward, animated: true, completion: nil)
        
        self.pageViewController.view.frame = CGRectMake(0, self.view.frame.size.height/18.9, self.view.frame.size.width, self.view.frame.size.height/1.055)
        
        self.addChildViewController(self.pageViewController)
        self.view.addSubview(self.pageViewController.view)
        self.pageViewController.didMoveToParentViewController(self)
    }
    
    override func viewWillAppear(animated: Bool) {
        
       

    }
    
    func getUserLikedStories(){
        tempArray.removeAll(keepCapacity: false)
        likedStories = LibraryAPI.sharedInstance.getStories()
        for story in likedStories{
            for string in story.likedBy{
                if (string == " \(User.sharedInstance.username)" || string == "\(User.sharedInstance.username)"){
                    tempArray.append(story)
                }
            }
            
        }
    }
    
    func presentAlert(){
    
    
    }
    
    func viewControllerAtIndex(index: Int) -> ContentViewController {
        
        if(( self.tempArray.count == 0) || (index >= self.tempArray.count)) {
            return ContentViewController()
        }
        var vc: ContentViewController = self.storyboard?.instantiateViewControllerWithIdentifier("ContentViewController") as! ContentViewController
        
        vc.typeController = type
        vc.story = tempArray[index]
        vc.pageIndex = index
        
        return vc
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        var vc = viewController as! ContentViewController
        var index = vc.pageIndex as Int
        
        if( (index == 0) || index == NSNotFound) {
            return nil
        }
        
        index--
        return self.viewControllerAtIndex(index)
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        var vc = viewController as! ContentViewController
        var index = vc.pageIndex as Int
        
        if( index == NSNotFound) {
            return nil
        }
        index++
        
        if( index == self.tempArray.count) {
            return nil
        }
        
        return self.viewControllerAtIndex(index)
    }
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return self.tempArray.count
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 0
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
