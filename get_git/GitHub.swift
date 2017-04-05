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
typealias FetchReposCompletion = ([Repository]?)->()



enum GitHubAuthError : Error {
    case extractingCode
}

enum SaveOptions{
    case userDefaults //almost the same as local storage, dangerous as it is used in clear text not encrypted.
}

class GitHub {
    
    private var session: URLSession
    private var components: URLComponents
    
    static let shared = GitHub()
    
    private init(){//this is making private vars valid
        
        self.session = URLSession(configuration: .default)
        self.components = URLComponents()
        
        self.components.scheme = "https"
        self.components.host = "api.github.com"
        
        if let token = UserDefaults.standard.getAccessToken(){
            let queryItem = URLQueryItem(name: "access_token", value: token) //URLQueryItem builds our the url for us
            self.components.queryItems = [queryItem]//it is then inserted into the array
        }
        
    }
    
    
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
                        //access_token=ijwe8ud9shdfuiq9hq
                        if let token = self.accessTokenFrom(dataString) {
                            // ijwe8ud9shdfuiq9hq
                            if UserDefaults.standard.save(accessToken: token) {
                                print("saved token to userDefaults")
                                let queryItem = URLQueryItem(name: "access_token", value: token) //URLQueryItem builds our the url for us
                                self.components.queryItems = [queryItem]//it is then inserted into the array
                            }
                        }
                        
                        print(dataString)
                        
                        complete(success: true)//complete is the function in the tokenRequestFor func
                    }
                    
                }).resume() //common bug in production code, just tells the dataTask to execute!
            }
            
        } catch {
            
        }
    }
    //escaping because it is requesting something out to the network for the repos
    func getRepos(completion: @escaping FetchReposCompletion) {
        
        func returnToMain(results: [Repository]?){
            OperationQueue.main.addOperation {
                completion(results)
            }
        }
        
        self.components.path = "/user/repos"

        guard let url = self.components.url else { returnToMain(results: nil); return }
        
        self.session.dataTask(with: url) { (data, response, error) in
            
            if error != nil { returnToMain(results: nil); return}//return here to prevent fall through
            
            if let data = data {
                
                var repositories = [Repository]()//var so that you can mutate and add more repos
                
                do{
                    if let rootJson = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [[String : Any]]{
                        
                        for repositoryJSON in rootJson {
                            if let repo = Repository(json: repositoryJSON){
                                repositories.append(repo)
                            }
                        }
                        returnToMain(results: repositories)
                        
                        print(rootJson)
                        
                    }
                } catch {
                
                }
                
                
                
            }
            
        }.resume()//add this or it wont happen, common bug
    }
    /////////////////THIS IS THE WAY TO SEPERATE OUT THE STRING TO JUST ACCESS THE TOKEN WITHOUT THE REST OF THE STRING///////////////
    func accessTokenFrom(_ string: String) -> String? {
        if string.contains("access_token") {
            let components = string.components(separatedBy: "&")
            
            for component in components{
                if component.contains("access_token"){
                    let token = component.components(separatedBy: "=").last
                    return token
                }
            }
        }
        return nil
    }
    
    
}







