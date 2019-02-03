//
//  MemberDetailViewController.swift
//  DALI Dashboard
//
//  Created by Shreyas Agnihotri on 2/3/19.
//  Copyright © 2019 Shreyas Agnihotri. All rights reserved.
//

import UIKit

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
        memberImageView.layer.cornerRadius = memberImageView.frame.height / 2
        memberImageView.clipsToBounds = true
        
        memberTermsLabel.text = arrayToString(list: member.termsOn)
        memberProjectsLabel.text = arrayToString(list: member.projects)
        
    }
    
    func arrayToString(list: [String]) -> String {
        var workingString = ""
        
        if list.isEmpty {
            print("list is empty")
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
