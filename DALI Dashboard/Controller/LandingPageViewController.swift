//
//  LandingPageViewController.swift
//  DALI Dashboard
//
//  Created by Shreyas Agnihotri on 2/5/19.
//  Copyright © 2019 Shreyas Agnihotri. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SCLAlertView

class LandingPageViewController: UIViewController {
    
    @IBOutlet weak var membersButton: UIButton!
    @IBOutlet weak var mapButton: UIButton!
    
    let DATA_URL = "https://raw.githubusercontent.com/dali-lab/mappy/gh-pages/members.json"
    let URL_PREFIX = "https://raw.githubusercontent.com/dali-lab/mappy/gh-pages/"
    var memberList = [Member]()

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.setButtonProperties(button: self.membersButton)
        self.setButtonProperties(button: self.mapButton)
        
        getMemberData(url: DATA_URL)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Show the navigation bar on other view controllers
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    //MARK: Networking
    
    func getMemberData(url: String) {
        
        Alamofire.request(url).responseJSON { response in
            
            if response.result.isSuccess {
                let membersJSON: JSON = JSON(response.result.value!)
                self.populateMemberList(json: membersJSON)
                //SCLAlertView().showSuccess("Awesome!", subTitle: "All the data loaded up.")
            }
                
            else {
                //Display error
                SCLAlertView().showError("Oops!", subTitle: "Looks like there was an error fetching the data. Please try again another time.")
            }
        }
        
    }
    
    func populateMemberList(json: JSON) {
        
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
            
            for (_, coordinate) in memberData["lat_long"] {
                newMember.coordinates.append(coordinate.doubleValue)
            }
            
            memberList.append(newMember)
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if(segue.identifier == "goToMembers") {
            let membersView = segue.destination as! MembersViewController
            membersView.memberList = self.memberList
        }
        
        if(segue.identifier == "goToMap") {
            let mapView = segue.destination as! MemberMapViewController
            mapView.memberList = self.memberList
        }
    }
    
    func setButtonProperties(button: UIButton) {
        
        UIView.animate(withDuration: 1) {
            button.layer.cornerRadius = 30
            button.layer.borderWidth = 3
            button.layer.borderColor = UIColor.white.cgColor
        }
        
    }

}
