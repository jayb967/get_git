//
//  RepoViewController.swift
//  get_git
//
//  Created by Rio Balderas on 4/4/17.
//  Copyright © 2017 Jay Balderas. All rights reserved.
//

import UIKit

class RepoViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var tableViewContainingRepos: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableViewContainingRepos.dataSource = self
        self.tableViewContainingRepos.delegate = self //this will make the segeu happen when cell is clicked
        
        let repoNib = UINib(nibName: RepositoryCell.identifier, bundle: Bundle.main)
        self.tableViewContainingRepos.register(repoNib, forCellReuseIdentifier: RepositoryCell.identifier)
        self.tableViewContainingRepos.estimatedRowHeight = 100
        self.tableViewContainingRepos.rowHeight = UITableViewAutomaticDimension

        self.searchBar.delegate = self
        
        update()

        // Do any additional setup after loading the view.
    }
    //array holding all repos that get pulled in from json
    var allReposArray = [Repository]() {
        didSet {
        self.tableViewContainingRepos.reloadData()
        }
    }
    
    var displayRepos: [Repository]? {
        didSet {
            self.tableViewContainingRepos.reloadData()
        }
    }
    
//    var displayRepos : [Repository]? {
//        didSet{
//            self.tableViewContainingRepos.reloadData()
//        }
//    }

    func update() {
        print("update repo controller here!!")
        
        GitHub.shared.getRepos { (repositories) in
            for repo in repositories! {
                self.allReposArray.append(repo)
            }
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if segue.identifier == RepoDetailViewController.identifier{
            
            //needs an extension to conform to protocol
            segue.destination.transitioningDelegate = self
            
            if let repoSelectedAtIndex = tableViewContainingRepos.indexPathForSelectedRow?.row{
                let selectedRepo = allReposArray[repoSelectedAtIndex]
                
                if let destinationController = segue.destination as? RepoDetailViewController{
                    destinationController.repo = selectedRepo
                }
            }
        
        }
    }

}
//MARK: RepoDetailViewController transitioning delegate
extension RepoViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        //it is returning the class made CustomTransition.swift to make the transiotn to the segue
        
        return CustomTransition(duration: 1.0)
        //this is telling it how it wants it transitioned from one controller to the other.
    }
}

//MARK: UITableViewDelegate
extension RepoViewController: UITableViewDelegate, UITableViewDataSource {
    
    //needed for UITableViewDatasource protocol
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allReposArray.count
    }
    //needed for UITableViewDatasource protocol
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableViewContainingRepos.dequeueReusableCell(withIdentifier: RepositoryCell.identifier, for: indexPath) as! RepositoryCell
        
        let currentRepoShowing = allReposArray[indexPath.row]
        
        cell.repoNameLabel.text = currentRepoShowing.name
        cell.descriptionLabel.text = currentRepoShowing.description
        cell.languageLabel.text = currentRepoShowing.language
        
        return cell
    }
    //this is the function that is makeing the cell selectiong to go onto the tableview details page
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: RepoDetailViewController.identifier, sender: nil)
    }
    
}
//MARK: UISearchBarDelegate
extension RepoViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if !searchText.validate() {
            let lastIndex = searchText.index(before: searchText.endIndex)
            searchBar.text = searchText.substring(to: lastIndex)
        }
        
        if let searchedText = searchBar.text {
            self.displayRepos = self.allReposArray.filter({$0.name.lowercased().contains(searchedText.lowercased())})
        }
        
        if searchBar.text == "" {
            self.displayRepos = nil
        }
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.displayRepos = nil
        self.searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.resignFirstResponder()
    }
    
    
}



//
//extension RepoViewController: UISearchBarDelegate {
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        
//        if !searchText.validate() {
//            //this will take off the last wrong character...it wont show in the text field..
//            let lastIndex = searchText.index(before: searchText.endIndex)
//            searchBar.text = searchText.substring(to: lastIndex)
//            //searchBar.text = "Invalid!"//will change the text in the search Bar
//            print(searchText)
//        }
//        
//        if let searchedText = searchBar.text {
//            self.allReposArray = self.allReposArray.filter({$0.name.contains(searchedText)})
//                self.allReposArray.reloadData()
//        }
//        if searhBar.text == ""{
//            self.displayRepos = nil
//        }
//    }
//    func searchBarCancelButtonClicked(_ searchBar: UISearchBar){
//    self.searchBar.resignFirstResponder() //this line toggles the keyboard off once search button pressed
//    }
//}
