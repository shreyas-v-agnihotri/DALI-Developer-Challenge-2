//
//  ViewController.swift
//  DALI Dashboard
//
//  Created by Shreyas Agnihotri on 2/2/19.
//  Copyright © 2019 Shreyas Agnihotri. All rights reserved.
//

import UIKit
import Kingfisher
import DZNEmptyDataSet

class MembersTableViewCell: UITableViewCell {
    
    @IBOutlet weak var memberNameLabel: UILabel!
    @IBOutlet weak var memberMessageLabel: UILabel!
    @IBOutlet weak var memberImageView: UIImageView!
    
}

class MembersViewController: UITableViewController, UISearchBarDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {

    var memberList = [Member]()
    var filteredList = [Member]()
    var displayList = [Member]()
    var selectedMember = Member()
    var searchBar = UISearchBar()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        displayList = memberList
        
        tableView.emptyDataSetSource = self as DZNEmptyDataSetSource
        tableView.emptyDataSetDelegate = self as DZNEmptyDataSetDelegate
        
        searchBar.delegate = self
        searchBar.searchBarStyle = UISearchBar.Style.minimal
        searchBar.setShowsCancelButton(true, animated: true)
        navigationItem.titleView = searchBar
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let str = "No DALI Lab members to show!"
        let attrs = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .headline)]
        return NSAttributedString(string: str, attributes: attrs)
    }
    

    //MARK: TableView Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return displayList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "member", for: indexPath) as! MembersTableViewCell
        
        cell.memberNameLabel?.text = displayList[indexPath.row].name
        cell.memberMessageLabel?.text = displayList[indexPath.row].message
        
        let convertedURL = URL(string: displayList[indexPath.row].imageURL)
        cell.memberImageView.kf.setImage(with: convertedURL)
        
        return cell
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        filteredList = memberList.filter({ (currentMember) -> Bool in
            currentMember.contains(query: searchBar.text!)
        })
        
        displayList = filteredList
        tableView.reloadData()
        if (!displayList.isEmpty) {
            tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: UITableView.ScrollPosition.top, animated: true)
        }
        
        DispatchQueue.main.async {
            self.view.endEditing(true)
        }
        
    }
    
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        searchBar.text = ""
        displayList = memberList
        tableView.reloadData()
        
        DispatchQueue.main.async {
            searchBar.resignFirstResponder()
        }
    }
    

    
    //MARK: Change Views
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectedMember = displayList[indexPath.row]
        self.performSegue(withIdentifier: "goToMemberDetail", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if(segue.identifier == "goToMemberDetail") {
            let memberDetail = segue.destination as! MemberDetailViewController
            memberDetail.member = selectedMember
        }
    }
}
