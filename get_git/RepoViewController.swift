//
//  RepoViewController.swift
//  get_git
//
//  Created by Rio Balderas on 4/4/17.
//  Copyright © 2017 Jay Balderas. All rights reserved.
//

import UIKit

class RepoViewController: UIViewController, UITableViewDataSource {
    
    @IBOutlet weak var tableViewContainingRepos: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableViewContainingRepos.dataSource = self
        update()

        // Do any additional setup after loading the view.
    }
    //array holding all repos that get pulled in from json
    var allReposArray = [Repository]() {
        didSet {
        self.tableViewContainingRepos.reloadData()
        }
    }

    func update() {
        print("update repo controller here!!")
        
        GitHub.shared.getRepos { (repositories) in
            for repo in repositories! {
                self.allReposArray.append(repo)
            }
        }
        
    }
    
    //needed for UITableViewDatasource protocol
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allReposArray.count
    }
      //needed for UITableViewDatasource protocol
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableViewContainingRepos.dequeueReusableCell(withIdentifier: "repoCell", for: indexPath)
        let currentRepoShowing = allReposArray[indexPath.row]
        
        cell.textLabel?.text = currentRepoShowing.name
        cell.detailTextLabel?.text = currentRepoShowing.description
        
        return cell
    }
    

}
