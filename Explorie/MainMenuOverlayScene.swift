//
//  MainMenuOverlayScene.swift
//  MainMenuExplorie
//
//  Created by Luan Barbalho Kalume on 25/05/15.
//  Copyright (c) 2015 Luan-BEPiD. All rights reserved.
//

import UIKit
import SpriteKit

protocol UserInterfaceDelegate
{
    func userTouchedIcon( icon:String )
}

class MainMenuSKScene: SKScene
{
    var interfaceDelegate:UserInterfaceDelegate? = nil
    /* Raio das circunferencias usados na criação das áreas de toque */
    var bigRadius:CGFloat!
    var smallRadius:CGFloat!
    
    override init(size: CGSize)
    {   
        super.init(size: size)
        var delegate:UserInterfaceDelegate? = nil
        
        let frameW = self.frame.size.width
        let frameH = self.frame.size.height
        
        bigRadius = self.frame.size.height/7
        smallRadius = bigRadius/8
        
        /* Bordas da tela */
        var outerBorder = SKShapeNode(path: createBorder(smallRadius), centered: false)
        var innerBorder = SKShapeNode(path: createBorder(smallRadius + 2), centered: false)
        outerBorder.lineWidth = 2.0
        innerBorder.lineWidth = 2.0
        outerBorder.strokeColor = UIColor(red: 49/255, green: 134/255, blue: 165/255, alpha: 1.0)
        innerBorder.strokeColor = UIColor(red: 49/255, green: 134/255, blue: 165/255, alpha: 1.0)
        
        /* Divisores entre os objetos */
        var upperDetail = SKShapeNode(path: createDetail(frameW/2, y: smallRadius*5 + bigRadius*4), centered: false)
        var lowerDetail = SKShapeNode(path: createDetail(frameW/2, y: smallRadius*3 + bigRadius*2), centered: false)
        upperDetail.lineWidth = 2.0
        lowerDetail.lineWidth = 2.0
        upperDetail.strokeColor = UIColor(red: 255/255, green: 69/255, blue: 89/255, alpha: 1.0)
        lowerDetail.strokeColor = UIColor(red: 255/255, green: 69/255, blue: 89/255, alpha: 1.0)
        
        /* Settings button */
        var settingsButton = SKSpriteNode(imageNamed: "Gear")
        settingsButton.name = "gear"
        settingsButton.position = CGPointMake(frameW - settingsButton.size.width/2 - smallRadius, settingsButton.size.height/2 + smallRadius)
        
        /* Cria as areas de toque dos botões */
        var penCircle = createCircle(bigRadius - smallRadius)
        var mapCircle = createCircle(bigRadius - smallRadius)
        var bookCircle = createCircle(bigRadius - smallRadius)
        penCircle.name = "penCircle"
        mapCircle.name = "mapCircle"
        bookCircle.name = "bookCircle"
        penCircle.position = CGPointMake(frameW/2, bigRadius + smallRadius*2)
        mapCircle.position = CGPointMake(frameW/2, bigRadius*3 + smallRadius*4)
        bookCircle.position = CGPointMake(frameW/2, bigRadius*5 + smallRadius*6)
        
        //        var sCirc1 = createCircle(smallRadius)
        //        sCirc1.position = CGPointMake(frameW/2, smallRadius)
        //        self.addChild(sCirc1)
        //        var sCirc2 = createCircle(smallRadius)
        //        sCirc2.position = CGPointMake(frameW/2, smallRadius*3 + bigRadius*2)
        //        self.addChild(sCirc2)
        //        var sCirc3 = createCircle(smallRadius)
        //        sCirc3.position = CGPointMake(frameW/2, smallRadius*5 + bigRadius*4)
        //        self.addChild(sCirc3)
        //        var sCirc4 = createCircle(smallRadius)
        //        sCirc4.position = CGPointMake(frameW/2, smallRadius*7 + bigRadius*6)
        //        self.addChild(sCirc4)
        
        self.addChild(outerBorder)
        self.addChild(innerBorder)
        self.addChild(upperDetail)
        self.addChild(lowerDetail)
        self.addChild(settingsButton)
        self.addChild(penCircle)
        self.addChild(mapCircle)
        self.addChild(bookCircle)
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent)
    {
        if let touch = touches.first as? UITouch
        {
            let touched = self.nodeAtPoint(touch.locationInNode(self))
            
            if touched.name == "gear"
            {
                interfaceDelegate!.userTouchedIcon(touched.name!)
            }
            else if touched.name == "bookCircle"
            {
                interfaceDelegate!.userTouchedIcon(touched.name!)
            }
            else if touched.name == "mapCircle"
            {
                interfaceDelegate!.userTouchedIcon(touched.name!)
            }
            else if touched.name == "penCircle"
            {
                interfaceDelegate!.userTouchedIcon(touched.name!)
            }
        }
        super.touchesBegan(touches, withEvent: event)
    }
    
    //MARK: Criação dos detalhes da tela
    func createDetail( x:CGFloat , y:CGFloat ) -> CGPath
    {
        var path = CGPathCreateMutable()
        
        CGPathMoveToPoint(path, nil, x - smallRadius, y)
        
        CGPathAddCurveToPoint(path, nil, x - smallRadius, y + smallRadius/2, x  - smallRadius*3, y, x - smallRadius - bigRadius, y)
        CGPathAddCurveToPoint(path, nil, x  - smallRadius*3, y, x - smallRadius, y - smallRadius/2, x - smallRadius, y)
        CGPathMoveToPoint(path, nil, x + smallRadius, y)
        CGPathAddCurveToPoint(path, nil, x + smallRadius, y + smallRadius/2, x + smallRadius*3, y, x + smallRadius + bigRadius, y)
        CGPathAddCurveToPoint(path, nil, x + smallRadius*3, y, x + smallRadius, y - smallRadius/2, x + smallRadius, y)
        
        CGPathMoveToPoint(path, nil, x + smallRadius/2, y + smallRadius/2)
        CGPathAddLineToPoint(path, nil, x - smallRadius/2, y - smallRadius/2)
        CGPathMoveToPoint(path, nil, x - smallRadius/2, y + smallRadius/2)
        CGPathAddLineToPoint(path, nil, x + smallRadius/2, y - smallRadius/2)
        
        return path
    }
    
    func createBorder( borderDistance : CGFloat ) -> CGPath
    {
        var path = CGPathCreateMutable()
        var cornerRadius:CGFloat = 60.0
        let smallRadius = borderDistance
        
        CGPathMoveToPoint(path, nil, borderDistance*2 + cornerRadius, borderDistance*2)
        CGPathAddLineToPoint(path, nil, self.frame.width - borderDistance*2 - cornerRadius, borderDistance*2)
        CGPathAddArc(path, nil, self.frame.width - borderDistance*2, borderDistance*2, cornerRadius, CGFloat(M_PI), CGFloat(M_PI)/2, true)
        CGPathAddLineToPoint(path, nil, self.frame.width - smallRadius*2, self.frame.height - smallRadius*2 - cornerRadius)
        CGPathAddArc(path, nil, self.frame.width - smallRadius*2, self.frame.height - smallRadius*2, cornerRadius, 3*CGFloat(M_PI)/2, CGFloat(M_PI), true)
        CGPathAddLineToPoint(path, nil, smallRadius*2 + cornerRadius, self.frame.height - smallRadius*2)
        CGPathAddArc(path, nil, smallRadius*2, self.frame.height - smallRadius*2, cornerRadius, 0, 3*CGFloat(M_PI)/2, true)
        CGPathAddLineToPoint(path, nil, smallRadius*2, smallRadius*2 + cornerRadius)
        CGPathAddArc(path, nil, smallRadius*2, smallRadius*2, cornerRadius, CGFloat(M_PI)/2, 0, true)
        
        return path
    }
    
    func createCircle(radius:CGFloat) -> SKShapeNode
    {
        var circle = SKShapeNode(circleOfRadius: radius)
        
        circle.lineWidth = 1.0;
        circle.alpha = 0.0
        
        return circle
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
