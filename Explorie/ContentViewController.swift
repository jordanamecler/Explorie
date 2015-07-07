//
//  ContentViewController.swift
//  Explorie
//
//  Created by Jordana Mecler on 10/06/15.
//  Copyright (c) 2015 Explories. All rights reserved.
//

import UIKit
import MapKit


class ContentViewController: UIViewController{

    var mapView:PopUpViewController!
    var pageIndex: Int!
    var backButton:UIButton!
    var scrollView:UIScrollView!
    var storyTitle:UILabel!
    var storyText:UITextView!
    var storyPhoto:UIImageView!
    var storyType:UIImageView!
    var likeButton:UIButton!
    var localButton:UIButton!
    var backgroundView:UIView!
    var story: Story!
    var isLiked = false
    var isPhotoBig = false
    var xPos:CGFloat!
    var yPos:CGFloat!
    var deleteButton:UIButton!
    var typeController:Int!

    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 255/255, green: 219/255, blue: 180/255, alpha: 1.0)
        
        var page = CAShapeLayer();
        page.frame = self.view.frame
        page.path = createPagePath()
        page.strokeColor = UIColor(red: 49/255, green: 134/255, blue: 165/255, alpha: 1.0).CGColor
        page.fillColor = UIColor(red: 250/255, green: 241/255, blue: 212/255, alpha: 1.0).CGColor
        page.lineWidth = 2.0
        self.view.layer.addSublayer(page)

        self.backButton = UIButton(frame: CGRectMake(self.view.frame.size.width*0.1,
                                                    self.view.frame.height/1.17,
                                                    self.view.frame.size.width/6.4,
                                                    self.view.frame.size.height/11.36))
        self.backButton.setTitleColor(UIColor(red: 0/255, green: 122/255, blue: 255/255, alpha: 1.0), forState: UIControlState.Normal)
        self.backButton.setImage(UIImage(named:"back"), forState: UIControlState.Normal)
        self.backButton.addTarget(self, action: "backButtonPressed", forControlEvents: .TouchUpInside)
        
        self.storyTitle = UILabel(frame: CGRectMake(0.0, 0.0, self.view.frame.size.width/1.28, self.view.frame.size.height/12.62))
        self.storyTitle.textAlignment = NSTextAlignment.Center
        self.storyTitle.center.x = self.view.center.x*1.05
        self.storyTitle.center.y = self.view.frame.size.height/28.4
        self.storyTitle.textColor = UIColor.blackColor()
        self.storyTitle.font = UIFont(name: "Noteworthy-Bold", size: 24)
        self.storyTitle.text = story.title
        
        self.storyType = UIImageView(frame: CGRectMake(0.0, 0.0, 40, 40))
        self.storyType.center.x = self.view.center.x*1.8
        self.storyType.center.y = self.view.frame.size.height/28.4
        
        switch(story.type){
        case "0":
            storyType.image = UIImage(named: "MapPin")
            break
        case "1":
            storyType.image = UIImage(named: "FunnyPin")
            break
        case "2":
            storyType.image = UIImage(named: "OvercomePin")
            break
        case "3":
            storyType.image = UIImage(named: "GenericPin")
            break
        default:
            break
        }
        
        self.storyText = UITextView(frame: CGRectMake(0.0, 0, self.view.frame.width*0.82, self.view.frame.size.height*0.48))
        self.storyText.backgroundColor = UIColor.clearColor()
        self.storyText.center.x = self.view.center.x*1.05
        self.storyText.center.y = self.view.frame.size.height/1.7
        self.storyText.textAlignment = NSTextAlignment.Center
        self.storyText.font = UIFont(name: "Noteworthy-Bold", size: 16)
        self.storyText.userInteractionEnabled = true
        self.storyText.text = story.text
        self.storyText.editable = false
        self.storyText.scrollEnabled = true
        
        self.storyPhoto = UIImageView(frame: CGRectMake(0.0, 0.0, self.view.frame.size.width/2, self.view.frame.size.height/4))
        self.storyPhoto.center.x = self.view.center.x*1.05
        self.storyPhoto.center.y = self.view.frame.size.height/4.7
        self.storyPhoto.image = story.photo
        self.storyPhoto.userInteractionEnabled = true
        self.storyPhoto.addGestureRecognizer( UITapGestureRecognizer(target: self, action: "showAnimated") )
        
        likeButton = UIButton(frame: CGRectMake(0, self.view.frame.size.height/1.17, self.view.frame.size.width/6.4, self.view.frame.size.height/11.36))
        self.likeButton.setImage(UIImage(named:"Like"), forState: UIControlState.Normal)
        self.likeButton.addTarget(self, action: "likeStory", forControlEvents: UIControlEvents.TouchUpInside)
        
        localButton = UIButton(frame: CGRectMake(self.view.frame.width - self.view.frame.width*0.2, self.view.frame.size.height/1.17, self.view.frame.size.width/6.4, self.view.frame.size.height/11.36))
        self.localButton.setImage(UIImage(named:"Define"), forState: UIControlState.Normal)
        self.localButton.addTarget(self, action: "showOnMap", forControlEvents: UIControlEvents.TouchUpInside)

        
        self.backgroundView = UIView(frame: CGRectMake(0,0,self.view.frame.width,self.view.frame.height))
        self.backgroundView.backgroundColor = UIColor.blackColor()
        
        self.view.addSubview(backButton)
        self.view.addSubview(storyTitle)
        self.view.addSubview(storyText)
        self.view.addSubview(storyPhoto)
        self.view.addSubview(localButton)
        self.view.addSubview(storyType)

        
        if(typeController == 1)
            {
                self.deleteButton = UIButton(frame: CGRectMake(0, self.view.frame.size.height/1.17, self.view.frame.size.width/6.4, self.view.frame.size.height/11.36))
                self.deleteButton.center.x = self.view.frame.size.width/1.52
                self.deleteButton.setImage(UIImage(named:"Delete"), forState: UIControlState.Normal)
                self.deleteButton.addTarget(self, action: "deleteStory", forControlEvents: UIControlEvents.TouchUpInside)
                
                self.likeButton.center.x = self.view.frame.size.width/2.9

                self.view.addSubview(deleteButton)
                self.view.bringSubviewToFront(deleteButton)
        }else{
        
            self.likeButton.center.x = self.view.center.x

        }
        self.view.addSubview(likeButton)
        self.view.bringSubviewToFront(likeButton)
        
        for string in story.likedBy{
            if (string == " \(User.sharedInstance.username)" || string == "\(User.sharedInstance.username)"){
                isLiked = true
            }
        }
        
        if (!isLiked){
            likeButton.alpha = 0.3
        }

    }
    
    func createPagePath() -> CGPath
    {
        var path = CGPathCreateMutable()
        
        let width = self.view.frame.width
        let height = self.view.frame.height
        
        CGPathMoveToPoint(path, nil, width*0.08, height*0.01)
        CGPathAddQuadCurveToPoint(path, nil, width*0.3, -10.0, width + 1, 0)
        CGPathAddLineToPoint(path, nil, width + 1.0, height + 1.0)
        CGPathAddLineToPoint(path, nil, width*0.08, height + 1.0)
        CGPathAddLineToPoint(path, nil, width*0.08, height*0.01)
        
        CGPathAddQuadCurveToPoint(path, nil, width*0.045, -5.0, -1.0, height*0.01)
        CGPathAddLineToPoint(path, nil, -10.0, height + 1.0)
        CGPathAddLineToPoint(path, nil, width * 0.08, height + 1.0)
        
        return path
    }
    
    func showOnMap(){
        
        mapView = PopUpViewController()
        
        var map = MKMapView()
        map.frame = CGRectMake(0, 0, mapView.view.frame.size.width*0.725, mapView.view.frame.size.height*0.65)
        map.center.x = mapView.popUpView.center.x*0.8
        map.center.y = mapView.popUpView.center.y * 0.7
        
        mapView.popUpView.addSubview(map)
        
        mapView.showInView(self.view)
        
        let center = CLLocationCoordinate2D(latitude: story.local.latitude, longitude: story.local.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
        
        map.setRegion(region, animated: false)
        map.userInteractionEnabled = false
        
        var annotation = StoryAnnotation(coordinate:  CLLocationCoordinate2DMake(story.local.latitude, story.local.longitude), title: story.title, story:story)
        map.addAnnotation(annotation)

        
    
    }
    
    
    func showAnimated()
    {
        if (!isPhotoBig)
        {
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                self.storyPhoto.frame = UIScreen.mainScreen().bounds
                self.view.bringSubviewToFront(self.storyPhoto)
                self.storyPhoto.center.y = 2*self.view.center.y - UIScreen.mainScreen().bounds.height/2
                self.storyPhoto.contentMode = UIViewContentMode.ScaleAspectFit
                self.storyPhoto.backgroundColor = UIColor.blackColor()
            })
            isPhotoBig = true
        }
        else
        {
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                self.storyPhoto.frame = CGRectMake(0.0, 0.0, self.view.frame.size.width/2, self.view.frame.size.height/4)
                self.storyPhoto.center.x = self.view.center.x*1.05
                self.storyPhoto.center.y = self.view.frame.size.height/4.7
                self.storyPhoto.backgroundColor = UIColor.clearColor()
            })
            isPhotoBig = false
        }
    }
    
    
    func deleteStory()
    {
        let alerta = UIAlertController(title: "Deletar História", message: "Você tem certeza que quer deletar essa história?", preferredStyle: .Alert)
        let okAction: UIAlertAction = UIAlertAction(title: "Sim", style: .Default) { (action: UIAlertAction!) in self.deletar() }
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancelar", style: .Cancel ) { action -> Void in }
        
        alerta.addAction(okAction)
        alerta.addAction(cancelAction)
        
        self.presentViewController(alerta, animated: true, completion: nil)
    }
    
    func deletar()
    {
        LibraryAPI.sharedInstance.deleteStory(story)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func likeStory()
    {
        if(LibraryAPI.sharedInstance.isLoggedIn) {
            
            if (!isLiked)
            {
                story.likedBy.append(User.sharedInstance.username)
                LibraryAPI.sharedInstance.updateStory(story)
                likeButton.alpha = 1.0
                isLiked = true
            }
            else
            {
                for (var i = 0; i < story.likedBy.count; i++)
                {
                    var string = story.likedBy[i]
                    if (string == " \(User.sharedInstance.username)" || string == "\(User.sharedInstance.username)")
                    {
                        story.likedBy.removeAtIndex(i)
                        likeButton.alpha = 0.3
                        isLiked = false
                        LibraryAPI.sharedInstance.updateStory(story)
                    }
                }
                
            }

        }
        else {
            let alerta = UIAlertController(title: "Atenção", message: "Você precisa entrar com um login para curtir histórias.", preferredStyle: .Alert)
            let cancelAction: UIAlertAction = UIAlertAction(title: "OK", style: .Cancel) { action -> Void in }
            println("aaaa")
            alerta.addAction(cancelAction)
            self.presentViewController(alerta, animated: true, completion: nil)
        }

    }
    
    @IBAction func backButtonPressed()
    {
        dismissViewControllerAnimated(false, completion: nil)
    }
    

}
