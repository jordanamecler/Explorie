//
//  LibraryAPI.swift
//  Explorie
//
//  Created by Lorenzo Saraiva on 5/19/15.
//  Copyright (c) 2015 BEPID-PucRJ. All rights reserved.
//

import UIKit

class LibraryAPI: NSObject {
    
    private let storyDAO: StoryDAO
    
    private let userDAO: UserDAO
    
    private let isOnline: Bool = true
    
    var isLoggedIn = false
    
    var allStories = [Story]()
    
    var storyLat = 0.0
    
    var storyLong = 0.0

    
    class var sharedInstance: LibraryAPI {
        
        struct Singleton {
            
            static let instance = LibraryAPI()
        }
        return Singleton.instance
    }
    
    override init() {
        storyDAO = StoryDAO()
        userDAO = UserDAO()
        println("O init da API foi chamados")
        // Iniciar ligação com firebase
        // Checar se esta online para ver se faz o update ou não
        
        super.init()
    }
    
    func getStories() -> [Story] {
        return storyDAO.getStories()
    }
    
    
    func addStory(story: Story) -> String {
        if isOnline {
            
            if(storyDAO.addStory(story)){
                return "História cadastrada com sucesso"
            }
        }
        return "Erro salvando a história"
    }
    
    func getRandomStory()->Story{
        
        return storyDAO.getRandomStory()
    }
    
    func deleteStory(story: Story) {
        if isOnline {
            storyDAO.deleteStory(story)
        }
    }
    
    func updateStory(story:Story){
        if isOnline{
            storyDAO.updateStory(story)
        }
    }
    
    func saveUser(user: User,sender:UIViewController){
        if isOnline{
            userDAO.checkUser(user,sender: sender)
        }
    }
    
    func loginUser(user: User,sender:UIViewController){
        if isOnline{
            userDAO.loginUser(user,sender:sender)
        }
    }
}
