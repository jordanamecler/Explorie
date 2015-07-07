//
//  MainViewController.swift
//  Explorie
//
//  Created by Jordana Mecler on 19/05/15.
//  Copyright (c) 2015 Explories. All rights reserved.
//

import UIKit
import SpriteKit
import SceneKit


class MainViewController: UIViewController,UserInterfaceDelegate, UIGestureRecognizerDelegate
{
    
    var infoView:PopUpViewController!
    var centerX = CGFloat()
    var bookView = UIView()
    
    var sceneView: SCNView!
    var hudView: SKScene!
    var camera: SCNNode!
    var ground: SCNNode!
    var book: SCNNode!
    var pen: SCNNode!
    var map: SCNNode!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        sceneView = SCNView(frame: self.view.frame)
        sceneView.scene = SCNScene()
        self.view.addSubview(sceneView)
        
        let groundGeometry = SCNFloor()
        groundGeometry.reflectivity = 0.15
        let groundMaterial = SCNMaterial()
        groundMaterial.diffuse.contents = UIColor(red: 255/255, green: 219/255, blue: 180/255, alpha: 1.0)
        groundGeometry.materials = [groundMaterial]
        ground = SCNNode(geometry: groundGeometry)
        
        /* Criação dos objetos */
        createCameraAndLight()
        createBook()
        createMap()
        createPen()
        
        /* Cria uma rotação completa no eixo z */
        let spin = CABasicAnimation(keyPath: "rotation")
        spin.fromValue = NSValue(SCNVector4: SCNVector4Make(0, 1, 0, 0))
        spin.toValue = NSValue(SCNVector4: SCNVector4Make(0, 1, 0, -Float(2 * M_PI)))
        spin.duration = 30
        spin.repeatCount = .infinity
        
        /* Adiciona as rotações nos objetos */
        book.addAnimation(spin, forKey: "spin around")
        map.addAnimation(spin, forKey: "spin around")
        pen.addAnimation(spin, forKey: "spin around")
        
        sceneView.scene?.rootNode.addChildNode(self.camera)
        sceneView.scene?.rootNode.addChildNode(ground)
        sceneView.scene?.rootNode.addChildNode(book)
        sceneView.scene?.rootNode.addChildNode(map)
        sceneView.scene?.rootNode.addChildNode(pen)
        
        /* Criação do HUD */
        let hud = MainMenuSKScene(size: sceneView.frame.size)
        hud.interfaceDelegate = self
        
        sceneView.overlaySKScene = hud;
        
    }
    
    func userTouchedIcon(icon: String)
    {
        if icon == "gear"
        {
            self.settingsButtonPressed()
        }
        else if icon == "bookCircle"
        {
            bookView.frame = self.view.frame
            bookView.backgroundColor = UIColor.clearColor()
            self.view.addSubview(bookView)
            
            var height = self.view.frame.height * 0.08
            

            
            var page = CAShapeLayer();
            page.frame = self.view.frame
            page.path = createPagePath()
            page.strokeColor = UIColor(red: 49/255, green: 134/255, blue: 165/255, alpha: 1.0).CGColor
            page.fillColor = UIColor(red: 250/255, green: 241/255, blue: 212/255, alpha: 1.0).CGColor
            page.lineWidth = 2.0
            bookView.layer.addSublayer(page)
            
            /* *********************************************
            Declaração dos botões */
            
            var myStoriesButton = UIButton()
            myStoriesButton.frame = CGRectMake(0, 0, 250, 40)
            myStoriesButton.layer.cornerRadius = 20
            myStoriesButton.setTitle("Minhas Histórias", forState: UIControlState.Normal)
            myStoriesButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
            myStoriesButton.center.x = self.view.center.x * 1.05
            myStoriesButton.center.y = self.view.frame.height/2 - self.view.frame.height/3 + height
            myStoriesButton.titleLabel!.font = UIFont(name: "LittleLordFontleroyNF", size: 52)
            myStoriesButton.addTarget(self, action: "myStoriesButtonPressed", forControlEvents: .TouchUpInside)
            
            var savedStoriesButton = UIButton()
            savedStoriesButton.frame = CGRectMake(0, 0, 250, 40)
            savedStoriesButton.layer.cornerRadius = 20
            savedStoriesButton.setTitle("Favoritas", forState: UIControlState.Normal)
            savedStoriesButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
            savedStoriesButton.center.x = self.view.center.x * 1.05
            savedStoriesButton.center.y = self.view.frame.height/2
            savedStoriesButton.titleLabel!.font = UIFont(name: "LittleLordFontleroyNF", size: 52)
            savedStoriesButton.addTarget(self, action: "savedStoriesButtonPressed", forControlEvents: .TouchUpInside)
            
            var explorieButton = UIButton()
            explorieButton.frame = CGRectMake(0, 0, 200, 40)
            explorieButton.layer.cornerRadius = 20
            explorieButton.setTitle("Explorie", forState: UIControlState.Normal)
            explorieButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
            explorieButton.center.x = self.view.center.x*1.05
            explorieButton.center.y = self.view.frame.height/2 + self.view.frame.height/3 - height
            explorieButton.titleLabel!.font = UIFont(name: "LittleLordFontleroyNF", size: 52)
            explorieButton.addTarget(self, action: "explorieButtonPressed", forControlEvents: .TouchUpInside)
            
            
            /* ********************************************* */
            
            /* *********************************************
            Adiciona os elementos a view */
            
            bookView.addSubview(explorieButton)
            bookView.addSubview(myStoriesButton)
            bookView.addSubview(savedStoriesButton)
            
            /* ********************************************* */
            
            /* *********************************************
            Adiciona o gesto de voltar */
            
            var voltar = UIScreenEdgePanGestureRecognizer(target: self, action: "moveViewWithGesture:")
            voltar.delegate = self
            voltar.edges = UIRectEdge.Left
            bookView.addGestureRecognizer(voltar)
            
            centerX = bookView.bounds.size.width / 2
            
            /* ********************************************* */

            
            
            //performSegueWithIdentifier("bookView", sender: nil)
        }
        else if icon == "mapCircle"
        {
            performSegueWithIdentifier("mapView", sender: nil)
        }
        else if icon == "penCircle"
        {
            if(LibraryAPI.sharedInstance.isLoggedIn) {
                performSegueWithIdentifier("newStoryView", sender: nil)
            }
            else {
                let alerta = UIAlertController(title: "Atenção", message: "Você precisa fazer login para escrever uma nova história.", preferredStyle: .Alert)
                let cancelAction: UIAlertAction = UIAlertAction(title: "OK", style: .Cancel) { action -> Void in }
                
                alerta.addAction(cancelAction)
                self.presentViewController(alerta, animated: true, completion: nil)
            }
        }
    }
    
    func createPagePath() -> CGPath
    {
        var path = CGPathCreateMutable()
        
        let width = self.view.frame.width
        let height = self.view.frame.height
        
        CGPathMoveToPoint(path, nil, width*0.09, height*0.08)
        CGPathAddQuadCurveToPoint(path, nil, width*0.3, height*0.02, width + 1, height*0.08)
        CGPathAddLineToPoint(path, nil, width + 1.0, height + 1.0)
        CGPathAddLineToPoint(path, nil, width*0.09, height + 1.0)
        CGPathAddLineToPoint(path, nil, width*0.09, height*0.08)
        
        CGPathAddQuadCurveToPoint(path, nil, width*0.045, height*0.06, -10.0, height*0.08)
        CGPathAddLineToPoint(path, nil, -10.0, height + 1.0)
        CGPathAddLineToPoint(path, nil, width * 0.09, height + 1.0)
        
        return path
    }
    
    func moveViewWithGesture(gesture:UIScreenEdgePanGestureRecognizer) {
        
        if( UIGestureRecognizerState.Began == gesture.state || UIGestureRecognizerState.Changed == gesture.state) {
            var translation = CGPoint()
            translation = gesture.translationInView(gesture.view!)
            bookView.center = CGPointMake(centerX + translation.x, bookView.center.y)
        }
        else {
            UIView.animateWithDuration(0.3, animations: {
                
                self.bookView.center = CGPointMake(self.centerX, self.bookView.center.y)
            })
        }
        if( bookView.center.x >= (self.view.frame.width * 1.2) )
        {
            bookView.removeFromSuperview()
        }
    }

    @IBAction func myStoriesButtonPressed() {
        if(LibraryAPI.sharedInstance.isLoggedIn) {
            
            var count = 0
            var likedStories = LibraryAPI.sharedInstance.getStories()
            for story in likedStories{
                if (story.creator == User.sharedInstance.username){
                        count++
                    }
                
                
            }
            
            if (count>0){
                performSegueWithIdentifier("myStoriesView", sender: nil)
            }else{
                let alerta = UIAlertController(title: "Atenção", message: "Você não tem histórias criadas!", preferredStyle: .Alert)
                let cancelAction: UIAlertAction = UIAlertAction(title: "OK", style: .Cancel) { action -> Void in }
                
                alerta.addAction(cancelAction)
                self.presentViewController(alerta, animated: true, completion: nil)
                
            }

        }
        else {
            let alerta = UIAlertController(title: "Atenção", message: "Você precisa entrar com um login para ver suas histórias.", preferredStyle: .Alert)
            let cancelAction: UIAlertAction = UIAlertAction(title: "OK", style: .Cancel) { action -> Void in }
            
            alerta.addAction(cancelAction)
            self.presentViewController(alerta, animated: true, completion: nil)

            
        }
    }
    
    @IBAction func savedStoriesButtonPressed() {
        if(LibraryAPI.sharedInstance.isLoggedIn) {
            
            var count = 0
            var likedStories = LibraryAPI.sharedInstance.getStories()
            for story in likedStories{
                for string in story.likedBy{
                    if (string == " \(User.sharedInstance.username)" || string == "\(User.sharedInstance.username)"){
                        count++
                    }
                }
                
            }
            
            if (count>0){
            performSegueWithIdentifier("savedStoriesView", sender: nil)
            }else{
                let alerta = UIAlertController(title: "Atenção", message: "Você não tem histórias favoritadas!", preferredStyle: .Alert)
                let cancelAction: UIAlertAction = UIAlertAction(title: "OK", style: .Cancel) { action -> Void in }
                
                alerta.addAction(cancelAction)
                self.presentViewController(alerta, animated: true, completion: nil)

            }
        }
        else {
            let alerta = UIAlertController(title: "Atenção", message: "Você precisa entrar com um login para ver histórias salvas.", preferredStyle: .Alert)
            let cancelAction: UIAlertAction = UIAlertAction(title: "OK", style: .Cancel) { action -> Void in }
            
            alerta.addAction(cancelAction)
            self.presentViewController(alerta, animated: true, completion: nil)
        }
    }
    
    @IBAction func explorieButtonPressed()
    {
        if (LibraryAPI.sharedInstance.getStories().count > 0){
            performSegueWithIdentifier("explorieView", sender: nil)
        }else{
            let alerta = UIAlertController(title: "Atenção", message: "Espere carregar as histórias!", preferredStyle: .Alert)
            let cancelAction: UIAlertAction = UIAlertAction(title: "OK", style: .Cancel) { action -> Void in }
            
            alerta.addAction(cancelAction)
            self.presentViewController(alerta, animated: true, completion: nil)
        }
    }
    

    /* Caso clique em informações */
    
    func settingsButtonPressed()
    {
        infoView = PopUpViewController()
        infoView.showInView(self.view)
        
        var about = UILabel()
        about.text = "App Desenvolvido por: \nJordana Mecler \nLorenzo Saraiva \nLuan Barbalho"
        about.frame = CGRectMake(0, 0, infoView.view.frame.size.width*0.65, infoView.view.frame.size.height*0.8)
        about.center.x = infoView.popUpView.center.x*0.8
        about.center.y = infoView.popUpView.center.y * 0.7
        about.textAlignment = NSTextAlignment.Center
        about.numberOfLines = 6
        
        var signOutButton = UIButton()
        signOutButton.frame = CGRectMake(0, infoView.popUpView.frame.height*0.75, 200, 30)
        signOutButton.layer.cornerRadius = 4
        signOutButton.backgroundColor = UIColor(red: 49/255, green: 134/255, blue: 165/255, alpha: 1.0)
        if ( LibraryAPI.sharedInstance.isLoggedIn == true )
        {
            signOutButton.setTitle("Sign Out", forState: UIControlState.Normal)
        }
        else
        {
            signOutButton.setTitle("Fazer Login", forState: UIControlState.Normal)
        }
        signOutButton.center.x = self.infoView.view.center.x*0.8
//        signOutButton.center.y = self.view.center.y+80
        //signOutButton.frame.size.height = infoView.view.frame.height - infoView.closeButton.frame.height*2

        signOutButton.addTarget(self, action: "signOutButtonPressed", forControlEvents: .TouchUpInside)

        
        infoView.popUpView.addSubview(about)
        infoView.popUpView.addSubview(signOutButton)

        
    }
    
    func signOutButtonPressed(){
    
        User.sharedInstance.username = nil
        User.sharedInstance.password = nil
        LibraryAPI.sharedInstance.isLoggedIn = false
        performSegueWithIdentifier("back", sender: nil)
    }
    
// MARK: Objects creation methods
    func createCameraAndLight()
    {
        let camera = SCNCamera()
        camera.zFar = 1000
        self.camera = SCNNode()
        self.camera.camera = camera
        self.camera.position = SCNVector3(x: -30, y: 25, z: 0)
        let constraint = SCNLookAtConstraint(target: ground)
        constraint.gimbalLockEnabled = true
        self.camera.constraints = [constraint]
        
        let ambientLight = SCNLight();
        ambientLight.castsShadow = false;
        ambientLight.color = UIColor.whiteColor();
        ambientLight.type = SCNLightTypeAmbient
        self.camera.light = ambientLight
    }

    func createBook()
    {
        let scene = SCNScene(named: "Storybook")
        
        book = scene!.rootNode.childNodeWithName("book", recursively: true)!
        book.scale = SCNVector3Make(0.15, 0.15, 0.15)
        book.pivot = SCNMatrix4MakeRotation(Float(M_PI_2), 1.0, 0.0, 0.0)
        book.position = SCNVector3Make(33, 1, 0)
    }
    
    func createMap()
    {
        let scene = SCNScene(named: "StoryMap")
        
        map = scene!.rootNode.childNodeWithName("map", recursively: true)!
        map.scale = SCNVector3Make(0.11, 0.11, 0.11)
        map.pivot = SCNMatrix4MakeRotation(Float(M_PI_2), 1.0, 0.0, 0.0)
        map.position = SCNVector3Make(-2, 1, 0)
    }
    
    func createPen()
    {
        let scene = SCNScene(named: "Pen")
        
        pen = scene!.rootNode.childNodeWithName("pen", recursively: true)!
        pen.scale = SCNVector3Make(0.025, 0.025, 0.025)
        pen.pivot = SCNMatrix4MakeRotation(Float(M_PI_2), 1.0, 0.0, 0.25)
        pen.position = SCNVector3Make(-18, 4.2, 0)
    }
}
