//
//  RepoDetailViewController.swift
//  get_git
//
//  Created by Rio Balderas on 4/5/17.
//  Copyright © 2017 Jay Balderas. All rights reserved.
//

import UIKit
import SafariServices

class RepoDetailViewController: UIViewController {

    @IBOutlet weak var repoNameDetailLabel: UILabel!
    @IBOutlet weak var descriptionDetailLabel: UILabel!
    @IBOutlet weak var languageDetailLabel: UILabel!
    @IBOutlet weak var numberOfStarsDetailLabel: UILabel!
    @IBOutlet weak var createdDetailLabel: UILabel!
    
    @IBOutlet weak var forkedOrNotDetailLabel: UILabel!
    
    @IBAction func doneButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func moreDetailsPressed(_ sender: Any) {
        guard let repo = repo else { return }
        
        presentWebViewControllerWith(urlString: repo.repoUrlString)
        presentSafariViewControllerWith(urlString: repo.repoUrlString)
        
    }
    ///above and below allow you to click on button and show actual url
    func presentSafariViewControllerWith(urlString: String) {
        guard let url = URL(string: urlString) else { return }
        
        let safariController = SFSafariViewController(url: url)
        self.present(safariController, animated: true, completion: nil)
    }
    
    func presentWebViewControllerWith(urlString: String) {
        let webController = WebViewController()
        webController.url = urlString
        
        self.present(webController, animated: true, completion: nil)
        
        
    }
    
    var repo : Repository!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.repoNameDetailLabel.text = repo.name
        self.descriptionDetailLabel.text =  repo.description
        self.languageDetailLabel.text = repo.language
        self.numberOfStarsDetailLabel.text = String(describing: "Number of Times Starred: \(repo.stars)")
        
        self.createdDetailLabel.text = repo.createdDate
        
        
        self.forkedOrNotDetailLabel.text = repo.isForked ? "Forked" : "Not forked"//this is a teranery operator which is a different form of if statement
       
    }
}


