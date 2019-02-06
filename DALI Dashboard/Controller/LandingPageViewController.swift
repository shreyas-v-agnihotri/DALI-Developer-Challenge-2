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
import SVProgressHUD

class LandingPageViewController: UIViewController {
    
    // Global variables
    @IBOutlet weak var membersButton: UIButton!
    @IBOutlet weak var mapButton: UIButton!
    
    // Provided JSON data
    let DATA_URL = "https://raw.githubusercontent.com/dali-lab/mappy/gh-pages/members.json"
    // Base DALI site for pictures and member websites
    let URL_PREFIX = "https://raw.githubusercontent.com/dali-lab/mappy/gh-pages/"
    // List of members in lab (to be fetched using HTTP Get)
    var memberList = [Member]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Show sprogress bar until all member data has been fetched
        SVProgressHUD.show()
        getMemberData(url: DATA_URL)
        SVProgressHUD.dismiss()
        
        // Animates and style buttons
        self.setButtonProperties(button: self.membersButton)
        self.setButtonProperties(button: self.mapButton)

    }
    
    // Handles memory overload
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    // MARK: UI Methods
    
    // Dismisses navigation bar in this view
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    // Enables navigation bar in other views

    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    // Creates rounded white border on passed button (animated)
    func setButtonProperties(button: UIButton) {
        
        UIView.animate(withDuration: 1) {
            button.layer.cornerRadius = 30
            button.layer.borderWidth = 3
            button.layer.borderColor = UIColor.white.cgColor
        }
    }

    
    //MARK: Networking
    
    // Fetches JSON data from URL
    func getMemberData(url: String) {
        
        // Uses Alamofire library to perform an HTTP Get
        Alamofire.request(url).responseJSON { response in
            
            // Initializes member list with data if JSON was retrieved
            if response.result.isSuccess {
                let membersJSON: JSON = JSON(response.result.value!)
                self.populateMemberList(json: membersJSON)
            }
                
            // Displays an error alert if HTTP Get was unsuccessful
            else {
                SVProgressHUD.showError(withStatus: "Looks like there was an error fetching the data.")
            }
        }
    }
    
    // Adds new members to member list with all properties set, given JSON array of member data
    func populateMemberList(json: JSON) {
        
        for (_, memberData) in json {
            let newMember = Member()
            
            newMember.name = memberData["name"].stringValue
            newMember.message = memberData["message"].stringValue
            
            // Formats image URL to avoid web-fetching errors and saves in corresponding member property
            let noSpaceImageURL = memberData["iconUrl"].stringValue.replacingOccurrences(of: " ", with: "%20")
            newMember.imageURL = "\(URL_PREFIX)\(noSpaceImageURL)"
            
            // Formats website URL to avoid web-fetching errors and saves in corresponding member property
            let noSpaceWebsiteURL = memberData["url"].stringValue.replacingOccurrences(of: " ", with: "%20")
            if (!noSpaceWebsiteURL.hasPrefix("//")) {       // Determines whether member website is independent or on DALI server
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
    
    
    // MARK: Change Views
    
    // Passes member list to members view or map view before switching
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // Members view
        if(segue.identifier == "goToMembers") {
            let membersView = segue.destination as! MembersViewController
            membersView.memberList = self.memberList
        }
        
        // Map view
        if(segue.identifier == "goToMap") {
            let mapView = segue.destination as! MemberMapViewController
            mapView.memberList = self.memberList
        }
    }
}
