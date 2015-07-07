//
//  UserDAO.swift
//  Explorie
//
//  Created by Lorenzo Saraiva on 5/25/15.
//  Copyright (c) 2015 BEPID-PucRJ. All rights reserved.
//

import UIKit

class UserDAO: NSObject {
    
    var userRef = Firebase(url:"https://sizzling-inferno-6992.firebaseio.com/users")
    
    func checkUser(user:User, sender:UIViewController){
        let updateRef = userRef.childByAppendingPath("\(user.username)")
        updateRef.observeSingleEventOfType(.Value, withBlock: { snapshot in
            if snapshot.value is NSNull {
                self.addUser(user)
                sender.performSegueWithIdentifier("mainView", sender: nil)
                LibraryAPI.sharedInstance.isLoggedIn = true
            }else{
                let alerta = UIAlertController(title: "Atenção", message: "Usuário já cadastrado.", preferredStyle: .Alert)
                let cancelAction: UIAlertAction = UIAlertAction(title: "OK", style: .Cancel) { action -> Void in }
                
                alerta.addAction(cancelAction)
                sender.presentViewController(alerta, animated: true, completion: nil)
            }
        })
    }
    
    func loginUser(user:User, sender:UIViewController){
        let updateRef = userRef.childByAppendingPath("\(user.username)")
        updateRef.observeSingleEventOfType(.Value, withBlock: { snapshot in
            if snapshot.value is NSNull {
                
                let alerta = UIAlertController(title: "Atenção", message: "Usuário não existe.", preferredStyle: .Alert)
                let cancelAction: UIAlertAction = UIAlertAction(title: "OK", style: .Cancel) { action -> Void in }
                
                alerta.addAction(cancelAction)
                sender.presentViewController(alerta, animated: true, completion: nil)
            }else{
                if (snapshot.value.objectForKey("password") as! String == user.password){
                    sender.performSegueWithIdentifier("mainView", sender: nil)
                    LibraryAPI.sharedInstance.isLoggedIn = true
                }else{
                    let alerta = UIAlertController(title: "Atenção", message: "Login ou senha inválidos.", preferredStyle: .Alert)
                    let cancelAction: UIAlertAction = UIAlertAction(title: "OK", style: .Cancel) { action -> Void in }
                    
                    alerta.addAction(cancelAction)
                    sender.presentViewController(alerta, animated: true, completion: nil)
                }
            }
        })
    }

    func addUser(user:User){
        
        let newUserRef = userRef.childByAppendingPath("\(user.username)")
        
        var password = ["password":"\(user.password)"]
    
        newUserRef.setValue(password, withCompletionBlock: {
            (error:NSError?, ref:Firebase!) in
            if (error != nil) {
                println("Data could not be saved.")
            } else {
                println("Data saved successfully!")
            }
        })
        
        
    }
    
}
