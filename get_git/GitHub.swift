//
//  GitHub.swift
//  get_git
//
//  Created by Rio Balderas on 4/3/17.
//  Copyright © 2017 Jay Balderas. All rights reserved.
//

import UIKit

let kOAuthBaseURLString = "https://github.com/login/oauth/" //best practice is to start with lower case "k" or "g" k represents a global constant

typealias GitHubAuthCompletion = (Bool)->()

enum GitHubAuthError : Error {
    case extractingCode
}

enum SaveOptions{
    case userDefaults //almost the same as local storage, dangerous as it is used in clear text not encrypted.
}

class GitHub {
    
    
    static let shared = GitHub()
    
    func oAuthRequestWith(parameters: [String : String]) {
        var parametersString = "" //will represent everything after question mark "?"
        
        for (key, value) in parameters {
            parametersString += "&\(key)=\(value)"//this is the interpolation of the second part of parameters
        }
        
        print("Parameters String : \(parametersString)")
        
        if let requestURL = URL(string: "\(kOAuthBaseURLString)authorize?client_id=\(kgitHubClientID)\(parametersString)"){
            print(requestURL.absoluteString)
            
            UIApplication.shared.open(requestURL)
            
        }//you get this from the docs that said authorize at the end of let constant at the top. you put in the rest of it at the end
    }
    
    func getCodeFrom(url: URL) throws -> String {
        //guard because it returns an optional
        guard let code = url.absoluteString.components(separatedBy: "=").last//every url has a string representation .absolutestring is a stringified version
            else {
                throw GitHubAuthError.extractingCode
        }
        return code //return code to be used in APPDELEGATE.SWIFT file
        
        
    }
    
    func tokenRequestFor(url: URL, saveOptions: SaveOptions, completion: @escaping GitHubAuthCompletion) {
        
        func complete(success: Bool){
            OperationQueue.main.addOperation {
                completion(success)
            }
        }
        do {
        
            let code = try self.getCodeFrom(url: url)//url is parameter that was passed in from tokenRequest
            
            let requestString = "\(kOAuthBaseURLString)access_token?client_id=\(kgitHubClientID)&client_secret=\(kgitHubClinetSecret)&code=\(code)"
            
            if let requestURL = URL(string: requestString){
                let session = URLSession(configuration: .default)//its one of the 3 configurations "default"
                session.dataTask(with: requestURL, completionHandler: { (data, response, error) in
                    
                    if error != nil { complete(success: false) }
                    guard let data = data else { complete(success: false); return } //needs ; to break since its a guard
                    
                    if let dataString = String(data: data, encoding: .utf8){
                        UserDefaults().save(accessToken: dataString)
                        print(dataString)
                        
                        complete(success: true)//complete is the function in the tokenRequestFor func
                    }
                    
                }).resume() //common bug in production code, just tells the dataTask to execute!
            }
            
        } catch {
            
        }
    }
}
