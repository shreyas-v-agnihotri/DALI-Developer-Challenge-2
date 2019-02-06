//
//  Member.swift
//  DALI Dashboard
//
//  Created by Shreyas Agnihotri on 2/2/19.
//  Copyright © 2019 Shreyas Agnihotri. All rights reserved.
//

import Foundation

// Data type representing a DALI Lab member (properties provided JSON data)
class Member {
    
    // Member properties
    var name: String = ""
    var imageURL: String = ""
    var website: String = ""
    var message: String = ""
    var termsOn = [String]()
    var projects = [String]()
    var coordinates = [Double]()
    
    // Returns whether any of member's properties contain passed query
    func contains(query: String) -> Bool {
        
        let lowercasedQuery = query.lowercased()    // Case-insensitive comparison
        
        // Loops through all terms
        for term in termsOn {
            if term.lowercased().contains(lowercasedQuery) {
                return true
            }
        }
        
        // Loops through all projects
        for project in projects {
            if project.lowercased().contains(lowercasedQuery) {
                return true
            }
        }
        
        // Compares query to name and message
        return name.lowercased().contains(lowercasedQuery) || message.lowercased().contains(lowercasedQuery)
    }
}
