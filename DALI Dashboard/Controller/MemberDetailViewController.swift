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
import SVProgressHUD

class MemberDetailViewController: UIViewController {
    
    // Global variables
    @IBOutlet weak var memberNameLabel: UILabel!
    @IBOutlet weak var memberImageView: UIImageView!
    @IBOutlet weak var memberTermsLabel: UILabel!
    @IBOutlet weak var memberProjectsLabel: UILabel!
    @IBOutlet weak var memberMessageLabel: UILabel!
    @IBOutlet weak var memberLocationLabel: UILabel!
    
    var member = Member()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        SVProgressHUD.show()        // Displays progress bar until all member data has loaded on screen

        memberNameLabel.text = member.name
        memberMessageLabel.text = member.message
        memberTermsLabel.text = arrayToString(list: member.termsOn)
        memberProjectsLabel.text = arrayToString(list: member.projects)
        
        setImage(imageURL: member.imageURL)
        setLocation(coordinates: member.coordinates)
        
        SVProgressHUD.dismiss()
                
    }
    
    // Handles memory overload
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    // MARK: Website View Handler
    
    // Opens member website in Safari viewer when website button is clicked
    @IBAction func memberWebsiteButton(_ sender: UIButton) {
        
        let siteURL = URL(string: member.website)
        let safari = SFSafariViewController(url: siteURL!)
        present(safari, animated: true, completion: nil)
        
    }
    
    
    // MARK: Location Helpers
    
    // Sets member location text given geo-coordinates
    func setLocation(coordinates: [Double]) {
        
        let location = CLLocation(latitude: coordinates[0], longitude: coordinates[1])
        let geocoder = CLGeocoder()
        
        // Uses MapKit's reverse-geocode functionality to determine address from coordinates
        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
            if error == nil {
                self.memberLocationLabel.text = self.formatLocation(placemark: (placemarks![0]))
            }
            else {
                self.memberLocationLabel.text = "Unknown"
            }
        }
    }
    
    // Parses placemark address and return optimal (most specific) location to display
    func formatLocation(placemark: CLPlacemark) -> String {
        
        // If in the US, return city and state
        if placemark.isoCountryCode == "US" {
            let city: String = placemark.locality!
            let state: String = placemark.administrativeArea!
            return "\(city), \(state)"
        }
        
        // If city is given, return city and country
        else if placemark.locality != nil {
            let city: String = placemark.locality!
            let country: String = placemark.country!
            return "\(city), \(country)"
        }
            
        // If region is given, return region and country
        else if placemark.administrativeArea != nil {
            let region: String = placemark.administrativeArea!
            let country: String = placemark.country!
            return "\(region), \(country)"
        }
            
        // If country is given, return country
        else if placemark.country != nil {
            let country: String = placemark.country!
            return "\(country)"
        }
            
        // If none of the above are given, return street address (name)
        else {
            let name: String = placemark.name!
            return "\(name)"
        }
    }
    
    
    // MARK: Misc. Helpers
    
    // Returns comma-separated String of items in array
    func arrayToString(list: [String]) -> String {
        var workingString = ""
        
        if list.isEmpty || list[0] == "" {
            workingString = "None :("           // Return simple message if list contains no Strings
        }
        else {
            for item in list {
                if !workingString.isEmpty {     // Insert comma before item only for non-first item
                    workingString += ", "
                }
                workingString += item
            }
        }
        return workingString
    }
    
    // Sets member image from given URL
    func setImage(imageURL: String) {
        
        let convertedURL = URL(string: imageURL)
        memberImageView.kf.setImage(with: convertedURL)
        
        // Creates rounded border
        memberImageView.layer.masksToBounds = true
        memberImageView.layer.cornerRadius = memberImageView.bounds.width/2
        
        // Optional: Sets border (in DALI Lab blue) around image
        // memberImageView.layer.borderWidth = 7
        // memberImageView.layer.borderColor = UIColor(red:0.25, green:0.67, blue:0.80, alpha:1.0).cgColor
        
    }
}
