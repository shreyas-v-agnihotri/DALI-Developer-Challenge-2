//
//  MemberDetailViewController.swift
//  DALI Dashboard
//
//  Created by Shreyas Agnihotri on 2/3/19.
//  Copyright © 2019 Shreyas Agnihotri. All rights reserved.
//

import UIKit
import SafariServices
import MapKit

class MemberDetailViewController: UIViewController {
    
    @IBOutlet weak var memberNameLabel: UILabel!
    @IBOutlet weak var memberImageView: UIImageView!
    @IBOutlet weak var memberTermsLabel: UILabel!
    @IBOutlet weak var memberProjectsLabel: UILabel!
    @IBOutlet weak var memberMessageLabel: UILabel!
    @IBOutlet weak var memberLocationLabel: UILabel!
    
    var member = Member()

    override func viewDidLoad() {
        super.viewDidLoad()

        memberNameLabel.text = member.name
        memberMessageLabel.text = member.message
        memberTermsLabel.text = arrayToString(list: member.termsOn)
        memberProjectsLabel.text = arrayToString(list: member.projects)
        
        setImage(imageURL: member.imageURL)
        setLocation(coordinates: member.coordinates)
                
    }
    
    @IBAction func memberWebsiteButton(_ sender: UIButton) {
        
        let siteURL = URL(string: member.website)
        let safari = SFSafariViewController(url: siteURL!)
        present(safari, animated: true, completion: nil)
        
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
    
    func setImage(imageURL: String) {
        
        let convertedURL = URL(string: imageURL)
        memberImageView.kf.setImage(with: convertedURL)
        memberImageView.layer.masksToBounds = true
        memberImageView.layer.cornerRadius = memberImageView.bounds.width/2
        //memberImageView.layer.borderWidth = 7
        //memberImageView.layer.borderColor = UIColor(red:0.25, green:0.67, blue:0.80, alpha:1.0).cgColor
        
    }
    
    func setLocation(coordinates: [Double]) {
        
        let location = CLLocation(latitude: coordinates[0], longitude: coordinates[1])
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
            if error == nil {
                self.memberLocationLabel.text = self.formatLocation(placemark: (placemarks![0]))
            }
            else {
                self.memberLocationLabel.text = "Unknown"
            }
        
        }
        
    }
    
    func formatLocation(placemark: CLPlacemark) -> String {
        
        if placemark.isoCountryCode == "US" {
            let city: String = placemark.locality!
            let state: String = placemark.administrativeArea!
            return "\(city), \(state)"
        }
        else if placemark.locality != nil {
            let city: String = placemark.locality!
            let country: String = placemark.country!
            return "\(city), \(country)"
        }
        else if placemark.administrativeArea != nil {
            let region: String = placemark.administrativeArea!
            let country: String = placemark.country!
            return "\(region), \(country)"
        }
        else if placemark.country != nil {
            let country: String = placemark.country!
            return "\(country)"
        }
        else {
            let name: String = placemark.name!
            return "\(name)"
        }
    }

}
