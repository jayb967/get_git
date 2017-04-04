//
//  GitHubAuthController.swift
//  get_git
//
//  Created by Rio Balderas on 4/3/17.
//  Copyright © 2017 Jay Balderas. All rights reserved.
//

import UIKit

class GitHubAuthController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        hideUnhideLoginButton()
    }

    @IBAction func printTokenPressed(_ sender: Any) {
        
    }
    
    @IBOutlet weak var loginButtonOutlet: UIButton!
    
    func hideUnhideLoginButton() {
        if UserDefaults.standard.getAccessToken() == nil {
            print("Log in first")
            loginButtonOutlet.isEnabled = true
            loginButtonOutlet.isHidden = false
        } else {
            print("you are already logged in")
            loginButtonOutlet.isHidden = true
            loginButtonOutlet.isEnabled = false
        }
    }

    @IBAction func loginButtonPressed(_ sender: Any) {
        
        let parameters = ["scope" : "email,user"] //you get scope from the github docs
        
        GitHub.shared.oAuthRequestWith(parameters: parameters)
        
        
    }

}
