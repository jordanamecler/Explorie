//
//  NewStoryViewController.swift
//  Explorie
//
//  Created by Jordana Mecler on 21/05/15.
//  Copyright (c) 2015 Explories. All rights reserved.
//

import UIKit
import CoreLocation

class NewStoryViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate {
    
    var tituloTextField = UITextField()
    var textoTextView = UITextView()
    let imagePicker = UIImagePickerController()
    let mapPicker = ChoseLocalViewController()
    var imageChosen = UIImageView()
    var storyCoords = CLLocationCoordinate2D()
    var plusButton = UIButton()
    var checkImage = UIImageView()
    //types
    var typeView = UIView()
    var love = UIImageView()
    var funny = UIImageView()
    var overcoming = UIImageView()
    var generic = UIImageView()
    
    
    
    var chosenType:Int!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        var width = self.view.frame.width
        var height = self.view.frame.height
        
        var centerX:CGFloat = self.view.center.x * 1.05
        var centerY:CGFloat = self.view.center.y
        
        imagePicker.delegate = self
        
        var page = CAShapeLayer();
        page.frame = self.view.frame
        page.path = createPagePath()
        page.strokeColor = UIColor(red: 49/255, green: 134/255, blue: 165/255, alpha: 1.0).CGColor
        page.fillColor = UIColor(red: 250/255, green: 241/255, blue: 212/255, alpha: 1.0).CGColor
        page.lineWidth = 2.0
        self.view.layer.addSublayer(page)
        self.view.backgroundColor = UIColor.clearColor()
        
        var titulo = UILabel()
        titulo.frame = CGRectMake(0, 0, 100, 35)
        titulo.center.x = centerX
        titulo.center.y = height*0.1
        titulo.textAlignment = NSTextAlignment.Center
        titulo.text = "Título"
        titulo.font = UIFont(name: "LittleLordFontleroyNF", size: 35)
        titulo.textColor = UIColor.blackColor()
        
        tituloTextField.frame = CGRectMake(0, 0, width*0.65, height*0.05)
        tituloTextField.textAlignment = NSTextAlignment.Center
        tituloTextField.placeholder = "Título da história"
        tituloTextField.backgroundColor = UIColor.lightTextColor()
        tituloTextField.layer.cornerRadius = 10.0
        tituloTextField.layer.borderWidth = 1.0
        tituloTextField.center.x = centerX
        tituloTextField.center.y = titulo.center.y + tituloTextField.frame.height
        tituloTextField.text = ""
        tituloTextField.delegate = self
        
        var fotoLabel = UILabel()
        fotoLabel.frame = CGRectMake( centerX - tituloTextField.frame.width/2 , 0, 100, 35)
        fotoLabel.center.y = tituloTextField.center.y + fotoLabel.frame.height*1.5
        fotoLabel.textAlignment = NSTextAlignment.Left
        fotoLabel.text = "Foto"
        fotoLabel.font = UIFont(name: "LittleLordFontleroyNF", size: 35)
        fotoLabel.textColor = UIColor.blackColor()
        
        var local = UILabel()
        local.frame = CGRectMake( centerX + tituloTextField.frame.width/2 - 100 , 0, 100, 35)
        local.center.y = tituloTextField.center.y + local.frame.height*1.5
        local.textAlignment = NSTextAlignment.Right
        local.text = "Local"
        local.font = UIFont(name: "LittleLordFontleroyNF", size: 35)
        local.textColor = UIColor.blackColor()
        
        plusButton = UIButton()
        plusButton.frame = CGRectMake( centerX - tituloTextField.frame.width/2 , 0, 30, 30)
        plusButton.center.y = fotoLabel.center.y + fotoLabel.frame.height*1.2
        plusButton.setImage(UIImage(named: "Plus"), forState: UIControlState.Normal)
        plusButton.addTarget(self, action: "plusButtonPressed", forControlEvents: .TouchUpInside)
        
        checkImage = UIImageView(image:UIImage(named:"Check"))
        checkImage.frame = plusButton.frame
        checkImage.center.y = plusButton.center.y
        checkImage.center.x = plusButton.center.x + plusButton.frame.width*1.5
        checkImage.hidden = true
        
        var localButton = UIButton()
        localButton.frame = CGRectMake( centerX + tituloTextField.frame.width/2 - 30 , 0, 30, 30)
        localButton.center.y = local.center.y + local.frame.height*1.2
        localButton.setImage(UIImage(named: "Define"), forState: UIControlState.Normal)
        localButton.addTarget(self, action: "localButtonPressed", forControlEvents: .TouchUpInside)
        
        var salvarButton = UIButton()
        salvarButton.frame = CGRectMake(0, 0, 80, 40)
        salvarButton.backgroundColor = UIColor.lightTextColor()
        salvarButton.layer.cornerRadius = 15
        salvarButton.setTitle("Enviar", forState: UIControlState.Normal)
        salvarButton.addTarget(self, action: "salvarPressed", forControlEvents: .TouchUpInside)
        salvarButton.center.x = centerX + tituloTextField.frame.width/4
        salvarButton.center.y = self.view.frame.size.height - 40
        salvarButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
        
        var cancelButton = UIButton()
        cancelButton.frame = CGRectMake(0, 0, 80, 40)
        cancelButton.backgroundColor = UIColor.lightTextColor()
        cancelButton.layer.cornerRadius = 15
        cancelButton.setTitle("Cancelar", forState: UIControlState.Normal)
        cancelButton.addTarget(self, action: "cancelPressed", forControlEvents: .TouchUpInside)
        cancelButton.center.x = centerX - tituloTextField.frame.width/4
        cancelButton.center.y = self.view.frame.size.height - 40
        cancelButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
        
        addTypeView( cancelButton.frame.height )
        
        textoTextView.frame = CGRectMake(   0,
                                            plusButton.center.y + plusButton.frame.height,
                                            width*0.65,
                                            typeView.center.y - typeView.frame.height - plusButton.center.y - plusButton.frame.height/2 )
        textoTextView.layer.cornerRadius = 10
        textoTextView.backgroundColor = UIColor.lightTextColor()
        textoTextView.textAlignment = NSTextAlignment.Left
        textoTextView.center.x = centerX
        textoTextView.delegate = self
        textoTextView.text = "Escreva sua história aqui..."
        textoTextView.textColor = UIColor.lightGrayColor()
        textoTextView.font = UIFont(name: "Symbol", size: 15.0)
        textoTextView.layer.borderWidth = 1
        
        /* ********************************************* */
        
        self.view.addSubview(titulo)
        self.view.addSubview(tituloTextField)
        self.view.addSubview(textoTextView)
        self.view.addSubview(fotoLabel)
        self.view.addSubview(local)
        self.view.addSubview(localButton)
        self.view.addSubview(plusButton)
        self.view.addSubview(checkImage)
        self.view.addSubview(salvarButton)
        self.view.addSubview(cancelButton)
    }
    
    override func viewDidAppear(animated: Bool)
    {
        self.view.backgroundColor = UIColor(red: 255/255, green: 219/255, blue: 180/255, alpha: 1.0)
        storyCoords = CLLocationCoordinate2DMake(LibraryAPI.sharedInstance.storyLat, LibraryAPI.sharedInstance.storyLong)
    }
    
    override func viewWillDisappear(animated: Bool)
    {
        storyCoords = CLLocationCoordinate2DMake(0, 0)
    }
    
//MARK: Funções que criam o placeholder da área de texto
    func textViewDidBeginEditing(textView: UITextView)
    {
        self.view.center.y = self.view.center.y - 130
        
        if ( textView.text == "Escreva sua história aqui..." )
        {
            textView.text = ""
            textView.textColor = UIColor.blackColor()
        }
        textView.becomeFirstResponder()
    }
    
    func textViewDidEndEditing(textView: UITextView)
    {
        self.view.center.y = self.view.center.y + 130
        if ( textView.text == "" )
        {
            textView.text = "Escreva sua história aqui..."
            textView.textColor = UIColor.lightGrayColor()
        }
        textView.resignFirstResponder()
    }

//MARK: Criação da imagem de fundo
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
        
        CGPathAddQuadCurveToPoint(path, nil, width*0.045, height*0.06, -1.0, height*0.08)
        CGPathAddLineToPoint(path, nil, -1.0, height + 1.0)
        CGPathAddLineToPoint(path, nil, width * 0.09, height + 1.0)
        
        return path
    }
    
    @IBAction func plusButtonPressed()
    {
        
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .PhotoLibrary
        imagePicker.modalPresentationStyle = .Popover
        imagePicker.popoverPresentationController?.sourceView = imagePicker.view
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func addTypeView( height:CGFloat )
    {
        typeView = UIView()
        typeView.frame = CGRectMake(0, 0, self.view.frame.width*0.65, height*1.25)
        typeView.center.x = self.view.center.x*1.05
        typeView.center.y = self.view.frame.height - height * 2.3
        
        love = UIImageView(image:UIImage(named:"Love"))
        funny = UIImageView(image:UIImage(named:"Funny"))
        overcoming = UIImageView(image:UIImage(named:"Overcome"))
        generic = UIImageView(image:UIImage(named:"Generic"))
        
        var typeOneTap = UITapGestureRecognizer(target: self, action: "typeOneTap")
        var typeTwoTap = UITapGestureRecognizer(target: self, action: "typeTwoTap")
        var typeThreeTap = UITapGestureRecognizer(target: self, action: "typeThreeTap")
        var typeFourTap = UITapGestureRecognizer(target: self, action: "typeFourTap")
        
        love.addGestureRecognizer(typeOneTap)
        funny.addGestureRecognizer(typeTwoTap)
        overcoming.addGestureRecognizer(typeThreeTap)
        generic.addGestureRecognizer(typeFourTap)
        
        love.userInteractionEnabled = true
        funny.userInteractionEnabled = true
        overcoming.userInteractionEnabled = true
        generic.userInteractionEnabled = true
        
        love.alpha = 0.2
        funny.alpha = 0.2
        overcoming.alpha = 0.2
        generic.alpha = 0.2
        
        typeView.addSubview(love)
        typeView.addSubview(funny)
        typeView.addSubview(overcoming)
        typeView.addSubview(generic)
        
        love.frame = CGRectMake( typeView.frame.width/8 - height/2 , typeView.frame.height/2 - height/2 , height, height)
        funny.frame = CGRectMake(typeView.frame.width * 0.25 + typeView.frame.width/8 - height/2, typeView.frame.height/2 - height/2, height, height)
        overcoming.frame = CGRectMake(typeView.frame.width * 0.50 + typeView.frame.width/8 - height/2 , typeView.frame.height/2 - height/2, height, height)
        generic.frame = CGRectMake(typeView.frame.width * 0.75 + typeView.frame.width/8 - height/2 , typeView.frame.height/2 - height/2, height, height)
        
        self.view.addSubview(typeView)
    }
    
    func typeOneTap()
    {
            love.alpha = 1.0
            funny.alpha = 0.2
            overcoming.alpha = 0.2
            generic.alpha = 0.2
            chosenType = 0
    }
    
    func typeTwoTap()
    {
        love.alpha = 0.2
        funny.alpha = 1.0
        overcoming.alpha = 0.2
        generic.alpha = 0.2
        chosenType = 1
    }
    
    func typeThreeTap()
    {
        love.alpha = 0.2
        funny.alpha = 0.2
        overcoming.alpha = 1.0
        generic.alpha = 0.2
        chosenType = 2
    }
    
    func typeFourTap()
    {
        love.alpha = 0.2
        funny.alpha = 0.2
        overcoming.alpha = 0.2
        generic.alpha = 1.0
        chosenType = 3
    }
    
    func localButtonPressed()
    {
        presentViewController(mapPicker, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject])
    {
        var chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        imageChosen.contentMode = .ScaleAspectFit
        imageChosen.image = chosenImage
        
        plusButton.setImage(UIImage(named: "Cancel"), forState: UIControlState.Normal)
        
        checkImage.hidden = false
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController)
    {
        imageChosen.image = nil
        plusButton.setImage(UIImage(named: "Plus"), forState: UIControlState.Normal)
        checkImage.hidden = true
       
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool
    {
        if(range.length==0) {
            if(text == "\n") {
                textView.resignFirstResponder()
                return false
            }
        }
        return (count(textView.text.utf16) + count(text.utf16) - range.length <= 600)
    }
    
    /*Caso salve a história */
    
    @IBAction func salvarPressed()
    {
        var msg = "História cadastrada com sucesso"
        
        if(tituloTextField.text == "") {
            msg = "Por favor insira um título à história"
        }
        else if(textoTextView.text == "") {
            msg = "Por favor insira um texto à sua história"
        }
        else if(count(textoTextView.text) < 100)
        {
            msg = "Por favor insira uma história com no mínimo 100 caracteres"
        }
        else if(storyCoords.latitude == 0 && storyCoords.longitude == 0) {
            msg = "Por favor escolha o local da sua história"
        }
        else if(chosenType == nil){
            msg = "Por favor escolha o tipo da sua história"
            
        }else if (imageChosen.image == nil){
            msg = "Por favor escolha a foto da sua história"
            
        }
        else
        {
            var story = Story(storyPhoto: imageChosen.image!, storyTitle:tituloTextField.text ,storyText:textoTextView.text, storyType: "\(chosenType)", storyLocal:CLLocationCoordinate2DMake(storyCoords.latitude, storyCoords.longitude),storyCreator:User.sharedInstance.username)
            println(story.local.longitude)
            println(story.local.latitude)
            msg = LibraryAPI.sharedInstance.addStory(story)
            storyCoords.latitude = 0
            storyCoords.longitude = 0
            chosenType = nil
        }
        
        if( msg == "História cadastrada com sucesso" )
        {
            let alerta = UIAlertController(title: "Sucesso", message: "História enviada com sucesso", preferredStyle: .Alert)
            let okAction: UIAlertAction = UIAlertAction(title: "OK", style: .Default) { (action: UIAlertAction!) in self.historiaEnviada() }
            
            alerta.addAction(okAction)
            self.presentViewController(alerta, animated: true, completion: nil)
        }
        else {
            let alerta = UIAlertController(title: "Atenção", message: msg, preferredStyle: .Alert)
            let cancelAction: UIAlertAction = UIAlertAction(title: "OK", style: .Cancel) { action -> Void in }
            
            alerta.addAction(cancelAction)
            self.presentViewController(alerta, animated: true, completion: nil)
        }        
    }
    
    func historiaEnviada()
    {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool
    {
        let newLength = count(textField.text.utf16) + count(string.utf16) - range.length
        return newLength <= 20
    }
    
    @IBAction func cancelPressed()
    {
        storyCoords = CLLocationCoordinate2DMake(0, 0)
        dismissViewControllerAnimated(false, completion: nil)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
}
