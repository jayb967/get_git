//
//  RepoViewController.swift
//  get_git
//
//  Created by Rio Balderas on 4/4/17.
//  Copyright © 2017 Jay Balderas. All rights reserved.
//

import UIKit
import FoldingCell
import SafariServices

class RepoViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var tableViewContainingRepos: UITableView!
    
    fileprivate struct C {
        struct CellHeight {
            static let close: CGFloat = 110 // equal or greater foregroundView height
            static let open: CGFloat = 195 // equal or greater containerView height
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableViewContainingRepos.dataSource = self
        self.tableViewContainingRepos.delegate = self //this will make the segeu happen when cell is clicked
        
        let repoNib = UINib(nibName: RepositoryFoldingCellNIB.identifier, bundle: Bundle.main)
        self.tableViewContainingRepos.register(repoNib, forCellReuseIdentifier: RepositoryFoldingCellNIB.identifier)
        self.tableViewContainingRepos.estimatedRowHeight = 105
        self.tableViewContainingRepos.rowHeight = UITableViewAutomaticDimension
        let tempImageView = UIImageView(image: UIImage(named: "gitBackgroundGradient"))
        tempImageView.frame = self.tableViewContainingRepos.frame
        self.tableViewContainingRepos.backgroundView = tempImageView;
        
        self.searchBar.delegate = self
        
        update()

        // Do any additional setup after loading the view.
    }
    
    var cellHeights = (110..<300).map { _ in C.CellHeight.close }
    var repo : Repository!
    
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
    
    func update() {
        print("update repo controller here!!")
        
        GitHub.shared.getRepos { (repositories) in
            for repo in repositories! {
//                if repo.isPrivate == false{
                self.allReposArray.append(repo)
//                }
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeights[indexPath.row]
    }
    
    //needed for UITableViewDatasource protocol
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return displayRepos?.count ?? allReposArray.count
    }
    
    
    //needed for UITableViewDatasource protocol
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableViewContainingRepos.dequeueReusableCell(withIdentifier: RepositoryFoldingCellNIB.identifier, for: indexPath) as! RepositoryFoldingCellNIB
        
        let currentRepoShowing = allReposArray[indexPath.row]
        cell.delegate = self
        
        cell.repoNameLabel.text = currentRepoShowing.name
        cell.languageLabel.text = currentRepoShowing.language
        cell.backgroundColor = .clear
        
        return cell
    }
    
//    //this is the function that is making the cell selection go onto the tableview details page
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        self.performSegue(withIdentifier: RepoDetailViewController.identifier, sender: nil)
//    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? RepositoryFoldingCellNIB else {
            return
        }

        var duration = 0.0
        if cellHeights[indexPath.row] == 110 {
            cellHeights[indexPath.row] = 218
            cell.selectedAnimation(true, animated: true, completion: nil)
            duration = 0.5
        } else {
            // close
            cellHeights[indexPath.row] = 110
            cell.selectedAnimation(false, animated: true, completion: nil)
            duration = 0.8
        }
        let currentRepoShowing = allReposArray[indexPath.row]
        
        cell.repoNameDetailLabel.text = currentRepoShowing.name
        cell.descriptionDetailLabel.text =  currentRepoShowing.description
        cell.languageDetailLabel.text = currentRepoShowing.language
        cell.numberOfStarsDetailLabel.text = String(describing: "\(currentRepoShowing.stars)")
        cell.createdDetailLabel.text = currentRepoShowing.createdDate
        cell.forkedOrNotDetailLabel.text = currentRepoShowing.isForked ? "Forked" : "Not forked"//this is a teranery operator which is a different form of if statement
        
        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseOut, animations: {
            tableView.beginUpdates()
            tableView.endUpdates()
        }, completion: nil)
    }
    
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
    
    
}
//MARK: MyFoldingCellDelegate
extension RepoViewController: MyFoldingCellDelegate {
    func didTapMoreDetail(_ sender: Any?) {
        
        if let selectedIndex = self.tableViewContainingRepos.indexPathForSelectedRow?.row {
            let repo = self.allReposArray[selectedIndex]
        
        self.presentWebViewControllerWith(urlString: repo.repoUrlString)
        self.presentSafariViewControllerWith(urlString: repo.repoUrlString)
    }
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
            self.tableViewContainingRepos.reloadData()
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
