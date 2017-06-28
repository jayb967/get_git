//
//  WebViewController.swift
//  get_git
//
//  Created by Rio Balderas on 4/6/17.
//  Copyright © 2017 Jay Balderas. All rights reserved.
//

import UIKit
import WebKit //access to wk


//This makes it to take out all the buttons and looks like a web view
class WebViewController: UIViewController {
    
    let webView = WKWebView()
    
    var url: String!//needs to force unwrap because you need a url to use this
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let url = URL(string: self.url) else { return }
        
        webView.frame = self.view.frame
        self.view.addSubview(self.webView)
        
        let urlRequest = URLRequest(url: url)
        
        self.webView.load(urlRequest)//load has a load request to fire it off
        
    }



}
