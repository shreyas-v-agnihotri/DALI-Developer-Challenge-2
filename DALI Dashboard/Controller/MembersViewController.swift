//
//  ViewController.swift
//  DALI Dashboard
//
//  Created by Shreyas Agnihotri on 2/2/19.
//  Copyright © 2019 Shreyas Agnihotri. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Kingfisher
import DZNEmptyDataSet
import SCLAlertView

class MembersTableViewCell: UITableViewCell {
    
    @IBOutlet weak var memberNameLabel: UILabel!
    @IBOutlet weak var memberMessageLabel: UILabel!
    @IBOutlet weak var memberImageView: UIImageView!
    
}

class MembersViewController: UITableViewController, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    
    let DATA_URL = "https://raw.githubusercontent.com/dali-lab/mappy/gh-pages/members.json"
    let URL_PREFIX = "https://raw.githubusercontent.com/dali-lab/mappy/gh-pages/"
    var memberList = [Member]()
    var filteredList = [Member]()
    var displayList = [Member]()
    var selectedMember = Member()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.emptyDataSetSource = self as DZNEmptyDataSetSource
        tableView.emptyDataSetDelegate = self as DZNEmptyDataSetDelegate
        
        getMemberData(url: DATA_URL)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let str = "No DALI Lab Members to show at this time!"
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
    

    //MARK: Networking
    
    func getMemberData(url: String) {
        
        Alamofire.request(url).responseJSON { response in
            
            if response.result.isSuccess {
                
                let membersJSON: JSON = JSON(response.result.value!)
                self.populateMembersDisplay(json: membersJSON)
                //SCLAlertView().showSuccess("Awesome!", subTitle: "All the data loaded up.")

            }
            
            else {
                //Display error
                SCLAlertView().showError("Oops!", subTitle: "Looks like there was an error fetching the data. Please try again another time.")

            }
        }
        
    }
    
    func populateMembersDisplay(json: JSON) {
        
        for (_, memberData) in json {
            let newMember = Member()
            
            newMember.name = memberData["name"].stringValue
            newMember.message = memberData["message"].stringValue
            
            let noSpaceImageURL = memberData["iconUrl"].stringValue.replacingOccurrences(of: " ", with: "%20")
            newMember.imageURL = "\(URL_PREFIX)\(noSpaceImageURL)"
            
            let noSpaceWebsiteURL = memberData["url"].stringValue.replacingOccurrences(of: " ", with: "%20")
            if (!noSpaceWebsiteURL.hasPrefix("//")) {
                newMember.website = "\(URL_PREFIX)\(noSpaceWebsiteURL)"
            }
            else {
                newMember.website = "http:\(noSpaceWebsiteURL)"
            }
            
            for (_, term) in memberData["terms_on"] {
                newMember.termsOn.append(term.stringValue)
            }
            
            for (_, project) in memberData["project"] {
                newMember.projects.append(project.stringValue)
            }
            
            memberList.append(newMember)
        }
        
        displayList = memberList
        tableView.reloadData()
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

extension MembersViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {

        filteredList = memberList.filter({ (currentMember) -> Bool in
            currentMember.contains(query: searchBar.text!)
        })

        displayList = filteredList
        tableView.reloadData()

    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text?.count == 0 {
            
            displayList = memberList
            tableView.reloadData()

            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            
        }

    }

}
