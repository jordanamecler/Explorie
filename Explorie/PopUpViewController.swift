//
//  PopUpViewController.swift
//  Explorie
//
//  Created by Luan Barbalho Kalume on 01/06/15.
//  Copyright (c) 2015 Explories. All rights reserved.
//

import UIKit

class PopUpViewController: UIViewController
{

    var popUpView:UIView!
    var closeButton:UIButton!

    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.grayColor().colorWithAlphaComponent(0.5)
        self.view.alpha = 0.6
        
        self.popUpView = UIView(frame: CGRectMake(0.0, 0.0, self.view.frame.width*0.8, self.view.frame.height*0.75))
        self.popUpView.backgroundColor = UIColor.whiteColor()
        self.popUpView.center.x = self.view.center.x
        self.popUpView.center.y = self.view.center.y
        self.popUpView.layer.cornerRadius = 5
        self.popUpView.layer.shadowOpacity = 0.8
        self.popUpView.layer.shadowOffset = CGSizeMake(0.0, 0.0)
        self.view.addSubview(popUpView)
        
        self.closeButton = UIButton(frame: CGRectMake(self.popUpView.frame.size.width/2 - 30.0, self.popUpView.frame.height - 45.0, 60.0, 30.0))
        self.closeButton.setTitleColor(UIColor(red: 0/255, green: 122/255, blue: 255/255, alpha: 1.0), forState: UIControlState.Normal)
        self.closeButton.setTitle("Fechar", forState: UIControlState.Normal)
        self.closeButton.titleLabel?.textAlignment = NSTextAlignment.Center
        self.closeButton.addTarget(self, action: "closePopUp", forControlEvents: .TouchUpInside)
        self.popUpView.addSubview(closeButton)
        
    }
    
    @IBAction func closePopUp()
    {
        self.removeAnimated()
    }
    
    func showInView( view:UIView )
    {
        view.addSubview(self.view)
        self.showAnimated()
    }
    
    func showAnimated()
    {
        self.view.transform = CGAffineTransformMakeScale(1.3, 1.3)
        self.view.alpha = 0.0
        
        UIView.animateWithDuration(0.25, animations: { () -> Void in
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransformMakeScale(1.0, 1.0)
        })
    }
    
    func removeAnimated()
    {
        UIView.animateWithDuration(0.25, animations: {
            self.view.transform = CGAffineTransformMakeScale(1.3, 1.3)
            self.view.alpha = 0.0;
            }, completion:{(finished : Bool)  in
                if (finished)
                {
                    self.view.removeFromSuperview()
                }
        })
    }
    
//MARK: Funções necessárias
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
