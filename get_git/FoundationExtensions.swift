//
//  FoundationExtensions.swift
//  get_git
//
//  Created by Rio Balderas on 4/3/17.
//  Copyright © 2017 Jay Balderas. All rights reserved.
//

import Foundation

extension UserDefaults {
    
    func getAccessToken() -> String? {//string is optional since we can also return nil instead of just a string
        guard let token = UserDefaults.standard.string(forKey: "access_token") else { return nil }//standard is the singleton in UserDefaults
        return token
    }
    
    func save(accessToken: String) -> Bool {
        UserDefaults.standard.set(accessToken, forKey: "access_token")//use the set(value, forKey: String)
        return UserDefaults.standard.synchronize()//return a true or false on if the procedure went through correctly
    }
}
