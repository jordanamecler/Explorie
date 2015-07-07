//
//  ViewController.swift
//  Explorie
//
//  Created by Jordana Mecler on 19/05/15.
//  Copyright (c) 2015 Explories. All rights reserved.
//


import UIKit


class LoginViewController: UIViewController, UITextFieldDelegate
{
    var termsView:PopUpViewController!
    var usernameTextField:UITextField!
    var passwordTextField:UITextField!


    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 255/255, green: 219/255, blue: 180/255, alpha: 1.0)
        
        
        var border = CAShapeLayer();
        border.frame = self.view.frame
        border.path = createBorder( ((self.view.frame.height/7)/8)*2 )
        border.strokeColor = UIColor(red: 49/255, green: 134/255, blue: 165/255, alpha: 1.0).CGColor
        border.fillColor = UIColor.clearColor().CGColor
        border.lineWidth = 2.0
        self.view.layer.addSublayer(border)
        

        /* Trata o caso de não ter login */
        var logoImage:UIImageView = UIImageView(frame: CGRectMake(0, 0, self.view.frame.height*0.25, self.view.frame.height*0.25))
        logoImage.image = UIImage(named: "ExplorieLogo")
        logoImage.center.x = self.view.center.x + 10
        logoImage.center.y = logoImage.frame.height
        self.view.addSubview(logoImage)
        
        let logoText:UILabel = UILabel(frame: CGRectMake(0, 0, self.view.frame.width*0.9, self.view.frame.height*0.25))
        logoText.text = "Explorie"
        logoText.font = UIFont(name: "LittleLordFontleroyNF", size: 100.0)
        logoText.adjustsFontSizeToFitWidth = true
        logoText.textColor = UIColor(red: 255/255, green: 69/255, blue: 89/255, alpha: 1.0)
        logoText.textAlignment = NSTextAlignment.Center
        logoText.center.x = self.view.center.x
        logoText.center.y = self.view.center.y - logoText.frame.height/2
        self.view.addSubview(logoText)
        
        usernameTextField = UITextField()
        usernameTextField.frame = CGRectMake(0, 0, 200, 30)
        usernameTextField.center.x = self.view.center.x
        usernameTextField.center.y = (logoText.frame.height/2 + logoText.center.y)*1.05
        usernameTextField.textAlignment = NSTextAlignment.Center
        usernameTextField.placeholder = "Username"
        usernameTextField.backgroundColor = UIColor.whiteColor()
        usernameTextField.layer.cornerRadius = 4
        self.view.addSubview(usernameTextField)
        
        passwordTextField = UITextField()
        passwordTextField.frame = CGRectMake(0, 0, 200, 30)
        passwordTextField.center.x = self.view.center.x
        passwordTextField.center.y = (usernameTextField.frame.height/2 + usernameTextField.center.y)*1.06
        passwordTextField.secureTextEntry = true
        passwordTextField.textAlignment = NSTextAlignment.Center
        passwordTextField.placeholder = "Password"
        passwordTextField.backgroundColor = UIColor.whiteColor()
        passwordTextField.layer.cornerRadius = 4
        self.view.addSubview(passwordTextField)

        var signUpButton = UIButton()
        signUpButton.frame = CGRectMake(0, 0, 100, 30)
        signUpButton.layer.cornerRadius = 4
        signUpButton.backgroundColor = UIColor(red: 49/255, green: 134/255, blue: 165/255, alpha: 1.0)
        signUpButton.setTitle("Sign Up", forState: UIControlState.Normal)
        signUpButton.center.x = self.view.center.x-51
        signUpButton.center.y = (passwordTextField.frame.height/2 + passwordTextField.center.y)*1.1
        signUpButton.addTarget(self, action: "signUpButtonPressed", forControlEvents: .TouchUpInside)
        self.view.addSubview(signUpButton)

        var logInButton = UIButton()
        logInButton.frame = CGRectMake(0, 0, 100, 30)
        logInButton.layer.cornerRadius = 4
        logInButton.backgroundColor = UIColor(red: 49/255, green: 134/255, blue: 165/255, alpha: 1.0)
        logInButton.setTitle("Log In", forState: UIControlState.Normal)
        logInButton.center.x = self.view.center.x+51
        logInButton.center.y = (passwordTextField.frame.height/2 + passwordTextField.center.y)*1.1
        logInButton.addTarget(self, action: "logInButtonPressed", forControlEvents: .TouchUpInside)
        self.view.addSubview(logInButton)

        var skipLoginButton = UIButton()
        skipLoginButton.frame = CGRectMake(0, 0, 200, 30)
        skipLoginButton.layer.cornerRadius = 4
        skipLoginButton.backgroundColor = UIColor(red: 49/255, green: 134/255, blue: 165/255, alpha: 1.0)
        skipLoginButton.setTitle("Entrar sem login", forState: UIControlState.Normal)
        skipLoginButton.center.x = self.view.center.x
        skipLoginButton.center.y = (logInButton.frame.height/2 + logInButton.center.y)*1.065
        skipLoginButton.addTarget(self, action: "skipLoginButtonPressed", forControlEvents: .TouchUpInside)
        self.view.addSubview(skipLoginButton)
        
        
        var termsButton = UIButton()
        termsButton.frame = CGRectMake(0, 0, self.view.frame.size.width, 30)
        termsButton.center.x = self.view.center.x
        termsButton.center.y = self.view.frame.height - ((self.view.frame.height/7)/8 * 2) - termsButton.frame.height
        termsButton.titleLabel?.font = UIFont(name: "Symbol", size: 12.0)
        termsButton.titleLabel?.textAlignment = NSTextAlignment.Center
        termsButton.setTitleColor(UIColor(red: 49/255, green: 134/255, blue: 165/255, alpha: 1.0), forState: UIControlState.Normal)
        termsButton.setTitle("Termos de Responsabilidade", forState: UIControlState.Normal)
        termsButton.addTarget(self, action: "termsButtonPressed", forControlEvents: .TouchUpInside)
        self.view.addSubview(termsButton)

        println("No login tem \(LibraryAPI.sharedInstance.getStories().count) historias")
        
        
        usernameTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    /* Caso clique em Termos de Responsabilidade */
    @IBAction func termsButtonPressed()
    {
        termsView = PopUpViewController()

        var termos = UILabel()
        termos.frame = CGRectMake(0, 0, termsView.view.frame.size.width*0.725, termsView.view.frame.size.height*0.8)
        termos.center.x = termsView.popUpView.center.x*0.8
        termos.center.y = termsView.popUpView.center.y * 0.7
        termos.textAlignment = NSTextAlignment.Center
        termos.numberOfLines = 6
        termos.text = "Não nos responsabilizamos pelas histórias publicadas neste aplicativo. Cada história é de responsabilidade exclusiva do usuário que a publicou."
        
        termsView.popUpView.addSubview(termos)
        
        termsView.showInView(self.view)
    }
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
       
        textField.resignFirstResponder()
        return true
    }
    
    
    @IBAction func skipLoginButtonPressed()
    {
        LibraryAPI.sharedInstance.isLoggedIn = false
        performSegueWithIdentifier("mainView", sender: nil)
    }
    
    func signUpButtonPressed(){
        
        if (self.usernameTextField.text == "" || self.passwordTextField.text == "")
        {
            let alerta = UIAlertController(title: "Atenção", message: "Login ou senha inválido", preferredStyle: .Alert)
            let cancelAction: UIAlertAction = UIAlertAction(title: "OK", style: .Cancel) { action -> Void in }
            
            alerta.addAction(cancelAction)
            self.presentViewController(alerta, animated: true, completion: nil)
        }
        else
        {
            User.sharedInstance.username = usernameTextField.text
            User.sharedInstance.password = passwordTextField.text
            LibraryAPI.sharedInstance.saveUser(User.sharedInstance, sender: self)
        }

    }
    
    func logInButtonPressed()
    {
        
        if (self.usernameTextField.text == "" || self.passwordTextField.text == "")
        {
            let alerta = UIAlertController(title: "Atenção", message: "Login ou senha inválido", preferredStyle: .Alert)
            let cancelAction: UIAlertAction = UIAlertAction(title: "OK", style: .Cancel) { action -> Void in }
            
            alerta.addAction(cancelAction)
            self.presentViewController(alerta, animated: true, completion: nil)
        }
        else
        {
            User.sharedInstance.username = usernameTextField.text
            User.sharedInstance.password = passwordTextField.text
            LibraryAPI.sharedInstance.loginUser(User.sharedInstance, sender: self)
        }
        
    }
    
    /* Pegando informação e salvando novo usuário */
    func createUser()
    {
        
    }
    
    func createBorder( borderDistance : CGFloat ) -> CGPath
    {
        var path = CGPathCreateMutable()
        var cornerRadius:CGFloat = 40.0
        let innerBorder = borderDistance + 4
        let width = self.view.frame.width
        let height = self.view.frame.height
        
        CGPathMoveToPoint(path, nil, borderDistance, borderDistance)
        CGPathAddLineToPoint(path, nil, width - borderDistance, borderDistance)
        CGPathAddLineToPoint(path, nil, width - borderDistance, height - borderDistance)
        CGPathAddLineToPoint(path, nil, borderDistance, height - borderDistance)
        CGPathAddLineToPoint(path, nil, borderDistance, borderDistance)
        
        CGPathMoveToPoint(path, nil, innerBorder + cornerRadius, innerBorder )
        CGPathAddLineToPoint(path, nil, width - cornerRadius - innerBorder, innerBorder)
        CGPathAddArc(path, nil, width - innerBorder, innerBorder, cornerRadius, CGFloat(M_PI), CGFloat(M_PI)/2, true)
        CGPathAddLineToPoint(path, nil, width - innerBorder, height - innerBorder - cornerRadius)
        CGPathAddArc(path, nil, width - innerBorder, height - innerBorder, cornerRadius, -CGFloat(M_PI)/2, -CGFloat(M_PI), true)
        CGPathAddLineToPoint(path, nil, innerBorder + cornerRadius, height - innerBorder)
        CGPathAddArc(path, nil, innerBorder, height - innerBorder, cornerRadius, 0.0, -CGFloat(M_PI)/2, true)
        CGPathAddLineToPoint(path, nil, innerBorder, innerBorder + cornerRadius)
        CGPathAddArc(path, nil, innerBorder, innerBorder, cornerRadius, CGFloat(M_PI)/2, 0.0, true)
        
        CGPathMoveToPoint(path, nil, innerBorder, innerBorder)
        CGPathAddArc(path, nil, innerBorder, innerBorder, cornerRadius - 4, 0.0, CGFloat(M_PI)/2, false)
        CGPathAddLineToPoint(path, nil, innerBorder, innerBorder)
        
        CGPathMoveToPoint(path, nil, width - innerBorder, innerBorder)
        CGPathAddArc(path, nil, width - innerBorder, innerBorder, cornerRadius - 4, CGFloat(M_PI), CGFloat(M_PI)/2, true)
        CGPathAddLineToPoint(path, nil, width - innerBorder, innerBorder)
        
        CGPathMoveToPoint(path, nil, width - innerBorder, height - innerBorder)
        CGPathAddArc(path, nil, width - innerBorder, height - innerBorder, cornerRadius - 4, -CGFloat(M_PI)/2, -CGFloat(M_PI), true)
        CGPathAddLineToPoint(path, nil, width - innerBorder, height - innerBorder)
        
        CGPathMoveToPoint(path, nil, innerBorder, height - innerBorder)
        CGPathAddArc(path, nil, innerBorder, height - innerBorder, cornerRadius - 4, 0.0, -CGFloat(M_PI)/2, true)
        CGPathAddLineToPoint(path, nil, innerBorder, height - innerBorder)
        
        return path
    }
    
//MARK: Métodos associados ao login
    
   
    
    override func viewWillDisappear(animated: Bool) {
    }
    
    override func viewDidAppear(animated: Bool) {
        
    }
}

