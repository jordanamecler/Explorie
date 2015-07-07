//
//  User.swift
//  Explorie
//
//  Created by Lorenzo Saraiva on 5/19/15.
//  Copyright (c) 2015 BEPID-PucRJ. All rights reserved.
//

import Foundation


class User:NSObject {
    
    var username:String!
    var password:String!
    
    
    class var sharedInstance: User {
        
        struct Singleton {
            
            static let instance = User()
        }
        return Singleton.instance
    }
    
    
}