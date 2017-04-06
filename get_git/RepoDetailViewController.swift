//
//  RepoDetailViewController.swift
//  get_git
//
//  Created by Rio Balderas on 4/5/17.
//  Copyright © 2017 Jay Balderas. All rights reserved.
//

import UIKit

class RepoDetailViewController: UIViewController {

    @IBOutlet weak var repoNameDetailLabel: UILabel!
    @IBOutlet weak var descriptionDetailLabel: UILabel!
    @IBOutlet weak var languageDetailLabel: UILabel!
    @IBOutlet weak var numberOfStarsDetailLabel: UILabel!
    @IBOutlet weak var createdDetailLabel: UILabel!
    
    @IBOutlet weak var forkedOrNotDetailLabel: UILabel!
    var repo : Repository!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.repoNameDetailLabel.text = repo.name
        self.descriptionDetailLabel.text =  repo.description
        self.languageDetailLabel.text = repo.language
        self.numberOfStarsDetailLabel.text = String(describing: "Number of Times Starred: \(repo.stars)")
        
 //       //Attempt at formatting date with ISO8601DateFormatter but couldnt figure out options...
//        let dateFormatter = ISO8601DateFormatter()
//        let formattedCreatedDateIntoString = String(describing: dateFormatter.date(from: repo.createdDate))
//        let dateFormatWanted = dateFormatter.string(from: formattedCreatedDateIntoString, timeZone: nil, formatOptions: )
        
        self.createdDetailLabel.text = repo.createdDate
        
        
        self.forkedOrNotDetailLabel.text = repo.isForked ? "Forked" : "Not forked"//this is a teranery operator which is a different form of if statement
       
    }
    
    
    

 

}
