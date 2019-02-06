//
//  MemberMapViewController.swift
//  DALI Dashboard
//
//  Created by Shreyas Agnihotri on 2/5/19.
//  Copyright © 2019 Shreyas Agnihotri. All rights reserved.
//

import UIKit
import MapKit
import SVProgressHUD

class MemberMapViewController: UIViewController {

    // Global variables
    @IBOutlet weak var memberMap: MKMapView!    // Interactive Apple map view
    
    var memberList = [Member]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Displays loading bar until map has been populated
        SVProgressHUD.show()
        populateMap(members: memberList)
        SVProgressHUD.dismiss()
    }
    
    // Handles memory overload
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // Plots marker on map for hometown of each member in passed list
    func populateMap(members: [Member]) {
        
        for member in members {
            let annotation = MKPointAnnotation()
            annotation.title = member.name          // Prints member name under each marker
            annotation.coordinate = CLLocationCoordinate2DMake(member.coordinates[0], member.coordinates[1])
            memberMap.addAnnotation(annotation)
        }
        
    }

}
