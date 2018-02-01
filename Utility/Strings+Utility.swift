//
//  Strings+Utility.swift
//  SV Queuer
//
//  Created by Nicholas LoBue on 1/29/18.
//  Copyright © 2018 Silicon Villas. All rights reserved.
//

class StringConstants {
    class var baseUrl: String {
        return "https://queuer-production.herokuapp.com/api/v1/"
    }
    
    class var apiKey: String {
        return "apiKey"
    }
    
    class var loginErrorTitle: String {
        return "Ruh roh"
    }
    
    class var loginErrorCancelTitle: String {
        return ":("
    }
    
    class var projectsTitle: String {
        return "Projects"
    }
    
    class var tasksTitle: String {
        return "Tasks"
    }
    
    class var creatProjectPromptTitle: String {
        return "Project name"
    }
    
    class var createTaskPromptTitle: String {
        return "Task name"
    }
    
    class var okActionTitle: String {
        return "Ok"
    }
    
    class var cancelActionTitle: String {
        return "Cancel"
    }
    
    class var namePlaceholder: String {
        return "Name"
    }
    
    class func loginErrorDescription(error: Error) -> String {
        return error.localizedDescription + "\nMaybe check your internet?"
    }
}
