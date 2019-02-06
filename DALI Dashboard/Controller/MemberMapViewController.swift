//
//  MemberMapViewController.swift
//  DALI Dashboard
//
//  Created by Shreyas Agnihotri on 2/5/19.
//  Copyright © 2019 Shreyas Agnihotri. All rights reserved.
//

import UIKit
import MapKit

class MemberMapViewController: UIViewController {

    @IBOutlet weak var memberMap: MKMapView!
    var memberList = [Member]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        populateMap(members: memberList)
    }
    

    func populateMap(members: [Member]) {
        
        for member in members {
            let annotation = MKPointAnnotation()
            annotation.title = member.name
            annotation.coordinate = CLLocationCoordinate2DMake(member.coordinates[0], member.coordinates[1])
            memberMap.addAnnotation(annotation)
        }
        
    }

}
