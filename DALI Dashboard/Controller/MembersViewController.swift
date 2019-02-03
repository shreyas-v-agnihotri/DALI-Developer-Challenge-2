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

class MembersTableViewCell: UITableViewCell {
    
    @IBOutlet weak var memberNameLabel: UILabel!
    @IBOutlet weak var memberMessageLabel: UILabel!
    @IBOutlet weak var memberImageLabel: UIImageView!
    
}

class MembersViewController: UITableViewController {
    
    let DATA_URL = "https://raw.githubusercontent.com/dali-lab/mappy/gh-pages/members.json"

    let memberList = ["John"]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        getMemberData(url: DATA_URL)
        
    }

    //MARK: TableView Data Source Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memberList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "member", for: indexPath) as! MembersTableViewCell
        
        cell.memberNameLabel?.text = memberList[indexPath.row]
        cell.memberMessageLabel?.text = "What's poppin, this is what I'm all about. I love to code and stuff."
        
        return cell
    }
    
    //MARK: Networking
    
    func getMemberData(url: String) {
        
        Alamofire.request(url).responseJSON {
            response in
            
            if response.result.isSuccess {
                
                let membersJSON: JSON = JSON(response.result.value!)
                let alert = SCLAlertView()
                alert.showSuccess("Got the JSON!", subTitle: "Acquired DALI member data", closeButtonTitle: "Done", duration: 10.0)
                //print(membersJSON)
                //self.updateMembersList(json: membersJSON)
            }
            
            else {
                //Display error
            }
        }
        
    }
    
    func updateMembersList(json: JSON) {
        
        
        
    }
    
}

