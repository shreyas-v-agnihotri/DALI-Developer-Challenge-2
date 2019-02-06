//
//  MembersViewController.swift
//  DALI Dashboard
//
//  Created by Shreyas Agnihotri on 2/2/19.
//  Copyright © 2019 Shreyas Agnihotri. All rights reserved.
//

import UIKit
import Kingfisher
import DZNEmptyDataSet

// Represents format of a cell in the table; profile image with name and message preview
class MembersTableViewCell: UITableViewCell {
    
    @IBOutlet weak var memberNameLabel: UILabel!
    @IBOutlet weak var memberMessageLabel: UILabel!
    @IBOutlet weak var memberImageView: UIImageView!
    
}

class MembersViewController: UITableViewController, UISearchBarDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {

    // Global variables
    var memberList = [Member]()
    var filteredList = [Member]()
    var displayList = [Member]()        // Tracks which members to display (filtered list or full)
    var selectedMember = Member()       // Tracks which member was selected to pass to Member Detail view
    var searchBar = UISearchBar()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        displayList = memberList        // Displays full list by default
        
        // Enables table to display informational message when empty
        tableView.emptyDataSetSource = self as DZNEmptyDataSetSource
        tableView.emptyDataSetDelegate = self as DZNEmptyDataSetDelegate
        
        // Sets search bar as fixed title bar above page
        searchBar.delegate = self
        searchBar.searchBarStyle = UISearchBar.Style.minimal
        searchBar.setShowsCancelButton(true, animated: true)
        navigationItem.titleView = searchBar
    }
    
    // Handles memory overload
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    //MARK: TableView Setup
    
    // Sets number of rows in table to the number of members in the display list
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return displayList.count
    }
    
    // Sets the image, name, and message of a given row from the corresponding member in the display list
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "member", for: indexPath) as! MembersTableViewCell
        
        cell.memberNameLabel?.text = displayList[indexPath.row].name
        cell.memberMessageLabel?.text = displayList[indexPath.row].message
        
        // Asynchronous, cached image loading
        let convertedURL = URL(string: displayList[indexPath.row].imageURL)
        cell.memberImageView.kf.setImage(with: convertedURL)
        
        return cell
    }
    
    // Sets table to print informational message when content is empty
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let str = "No DALI Lab members to show!"
        let attrs = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .headline)]
        return NSAttributedString(string: str, attributes: attrs)
    }
    
    
    // MARK: Search Bar Methods
    
    // Filters and reloads table when a search is made
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        // Adds every member containing the search query to the filtered list
        filteredList = memberList.filter({ (currentMember) -> Bool in
            currentMember.contains(query: searchBar.text!)
        })
        
        // Sets display list to display filtered list and reloads table, scrolling to top
        displayList = filteredList
        tableView.reloadData()
        if (!displayList.isEmpty) {
            tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: UITableView.ScrollPosition.top, animated: true)
        }
    }
    
    // Erases existing text in search bar and dismisses keyboard
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        searchBar.text = ""
        
        // Sets table to display full list of members
        displayList = memberList
        tableView.reloadData()
        
        DispatchQueue.main.async {
            searchBar.resignFirstResponder()
        }
    }
    
    
    //MARK: Change Views
    
    // Records selected member and segues to Member Detail view
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectedMember = displayList[indexPath.row]
        self.performSegue(withIdentifier: "goToMemberDetail", sender: self)
        
    }
    
    // Passes member list to member detail view before switching
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if(segue.identifier == "goToMemberDetail") {
            let memberDetail = segue.destination as! MemberDetailViewController
            memberDetail.member = selectedMember
        }
    }
}
