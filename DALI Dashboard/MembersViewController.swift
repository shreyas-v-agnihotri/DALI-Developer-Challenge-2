//
//  ViewController.swift
//  DALI Dashboard
//
//  Created by Shreyas Agnihotri on 2/2/19.
//  Copyright © 2019 Shreyas Agnihotri. All rights reserved.
//

import UIKit

class MembersViewController: UITableViewController {

    let memberList = ["John", "Juan", "Tim"]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }

    //MARK - TableView data source methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memberList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "member", for: indexPath)
        cell.textLabel?.text = memberList[indexPath.row]
        
        return cell
    }
    
    
}

