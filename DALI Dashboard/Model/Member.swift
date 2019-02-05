//
//  Member.swift
//  DALI Dashboard
//
//  Created by Shreyas Agnihotri on 2/2/19.
//  Copyright © 2019 Shreyas Agnihotri. All rights reserved.
//

import Foundation

class Member {
    
    var name: String = ""
    var imageURL: String = ""
    var website: String = ""
    var message: String = ""
    var termsOn = [String]()
    var projects = [String]()
    var coordinates = [Double]()
    
    func contains(query: String) -> Bool {
        
        let lowercasedQuery = query.lowercased()
        
        for term in termsOn {
            if term.lowercased().contains(lowercasedQuery) {
                return true
            }
        }
        
        for project in projects {
            if project.lowercased().contains(lowercasedQuery) {
                return true
            }
        }
        
        return name.lowercased().contains(lowercasedQuery) || message.lowercased().contains(lowercasedQuery)
    }
    
}
