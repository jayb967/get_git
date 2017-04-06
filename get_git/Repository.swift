//
//  Repository.swift
//  get_git
//
//  Created by Rio Balderas on 4/4/17.
//  Copyright © 2017 Jay Balderas. All rights reserved.
//

import Foundation

class Repository {
    
    
    let name: String
    let stars: Int
    let createdDate: String
    let isForked: Bool
    
    let description: String?// if its nil
    let language: String?
    
    
    init?(json: [String: Any]) { //Any because we are unsure of what were going to unwrap
        print(json)
        

        
        if let name = json["name"] as? String, let stars = json["stargazers_count"] as? Int, let createdDate = json["created_at"] as? String, let isForked = json["forks"] as? Bool {
            
            self.name = name
            self.stars = stars
            
            self.isForked = isForked
            
            self.createdDate = "Created on: \(createdDate.formatCreatedDate()!)" //?? "No date"

            if let description = json["description"] as? String {
                self.description = description
            } else {
                self.description = "No description"
            }
            if let language = json["language"] as? String {
                self.language = "Written in \(language)"
            } else {
                self.language = "Language unknown"
            }

        } else {
            return nil
        }

    }
    

    
}
