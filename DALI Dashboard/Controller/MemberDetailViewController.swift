//
//  MemberDetailViewController.swift
//  DALI Dashboard
//
//  Created by Shreyas Agnihotri on 2/3/19.
//  Copyright © 2019 Shreyas Agnihotri. All rights reserved.
//

import UIKit

class MemberDetailViewController: UIViewController, MemberDelegate {
    
    var member = Member()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        print(member.name)
    }
    
    func showMemberDetail(selectedMember: Member) {
        member = selectedMember
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "goToMemberDetail" {
            
            let destinationViewController = segue.destination as! MembersViewController
            destinationViewController.delegate = self
            
        }
        
    }

}
