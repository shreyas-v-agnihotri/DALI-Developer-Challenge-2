//
//  MemberDetailViewController.swift
//  DALI Dashboard
//
//  Created by Shreyas Agnihotri on 2/3/19.
//  Copyright © 2019 Shreyas Agnihotri. All rights reserved.
//

import UIKit
import SafariServices

class MemberDetailViewController: UIViewController {
    
    @IBOutlet weak var memberNameLabel: UILabel!
    @IBOutlet weak var memberImageView: UIImageView!
    @IBOutlet weak var memberTermsLabel: UILabel!
    @IBOutlet weak var memberProjectsLabel: UILabel!
    @IBOutlet weak var memberMessageLabel: UILabel!
    
    var member = Member()

    override func viewDidLoad() {
        super.viewDidLoad()

        memberNameLabel.text = member.name
        memberMessageLabel.text = member.message
        
        let convertedURL = URL(string: member.imageURL)
        memberImageView.kf.setImage(with: convertedURL)
        memberImageView.layer.masksToBounds = true
        memberImageView.layer.cornerRadius = memberImageView.bounds.width/2
        // memberImageView.layer.borderWidth = 7
        // memberImageView.layer.borderColor = UIColor(red:0.25, green:0.67, blue:0.80, alpha:1.0).cgColor
        
        memberTermsLabel.text = arrayToString(list: member.termsOn)
        memberProjectsLabel.text = arrayToString(list: member.projects)
        
        
    }
    
    @IBAction func memberWebsiteButton(_ sender: UIButton) {
        
        let siteURL = URL(string: member.website)
        print(member.website)
        let safari = SFSafariViewController(url: siteURL!)
        present(safari, animated: true, completion: nil)
        //UIApplication.shared.open(siteURL!)
        
    }
    
    func arrayToString(list: [String]) -> String {
        var workingString = ""
        
        if list.isEmpty {
            workingString = "None :("
        }
        else {
            for item in list {
                if !workingString.isEmpty {
                    workingString += ", "
                }
                workingString += item
            }
        }
        
        return workingString
    }

}
