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

//implementing the regex
//MARK: REGEX
extension String{
    func validate() -> Bool {
        //defining the pattern no commas or slashes or it will count those too. ^ means that if its not this.
        let pattern = "[^0-9a-zA-Z_-]"
        
        do{
        let regex = try NSRegularExpression(pattern: pattern, options: .caseInsensitive)
            //defines where to start and where to stop
        let range = NSRange(location: 0, length: self.characters.count)
        //.reportCompletion just show a completion right away,
        let matches = regex.numberOfMatches(in: self, options: .reportCompletion, range: range)
            
            if matches > 0 {
                return false
            }
            
            return true //return here is there arent any matches and if it is less than 0 characters
            
        } catch {
            return false
        }
    }
}
