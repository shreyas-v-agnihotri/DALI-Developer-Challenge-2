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
import SCLAlertView_Objective_C
import Kingfisher

protocol MemberDelegate {
    func showMemberDetail (selectedMember: Member)
}

class MembersTableViewCell: UITableViewCell {
    
    @IBOutlet weak var memberNameLabel: UILabel!
    @IBOutlet weak var memberMessageLabel: UILabel!
    @IBOutlet weak var memberImageView: UIImageView!
    
}

class MembersViewController: UITableViewController {
    
    var delegate: MemberDelegate?
    
    let DATA_URL = "https://raw.githubusercontent.com/dali-lab/mappy/gh-pages/members.json"
    let IMAGE_URL_PREFIX = "https://raw.githubusercontent.com/dali-lab/mappy/gh-pages/"
    var memberList = [Member]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        getMemberData(url: DATA_URL)
        
    }

    //MARK: TableView Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memberList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "member", for: indexPath) as! MembersTableViewCell
        
        cell.memberNameLabel?.text = memberList[indexPath.row].name
        cell.memberMessageLabel?.text = memberList[indexPath.row].message
        
        let convertedURL = URL(string: memberList[indexPath.row].imageURL)
        cell.memberImageView.kf.setImage(with: convertedURL)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        delegate?.showMemberDetail(selectedMember: memberList[indexPath.row])
        self.performSegue(withIdentifier: "goToMemberDetail", sender: self)
        
    }
    
    
    //MARK: Networking
    
    func getMemberData(url: String) {
        
        Alamofire.request(url).responseJSON {
            response in
            
            if response.result.isSuccess {
                
                let membersJSON: JSON = JSON(response.result.value!)
                self.updateMembersDisplay(json: membersJSON)

                //let alert = SCLAlertView()
                //alert.showSuccess("Got the JSON!", subTitle: "Acquired DALI member data", closeButtonTitle: "Done", duration: 10.0)
            }
            
            else {
                //Display error
            }
        }
        
    }
    
    func updateMembersDisplay(json: JSON) {
        
        for (_, memberData) in json {
            let newMember = Member()
            
            newMember.name = memberData["name"].stringValue
            newMember.message = memberData["message"].stringValue
            newMember.website = memberData["url"].stringValue
            newMember.imageURL = "\(IMAGE_URL_PREFIX)\(memberData["iconUrl"].stringValue)"
            
            for (_, term) in memberData["terms_on"] {
                newMember.termsOn.append(term.stringValue)
            }
            
            for (_, project) in memberData["project"] {
                newMember.projects.append(project.stringValue)
            }
            
            self.memberList.append(newMember)
        }
        
        self.tableView.reloadData()
    }

    
}

