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
    let description: String?
    let language: String?
     
    
    
    init?(json: [String: Any]) { //Any because we are unsure of what were going to unwrap
        print(json)
        if let name = json["name"] as? String, let description = json["description"] as? String, let language = json["language"] as? String{
            self.name = name
            self.description = description
            self.language = language
        } else {
            return nil
        }

    }
    
}
