//
//  InformationPostViewController.swift
//  On the map
//
//  Created by Admin on 15.06.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class InformationPostViewController:UIViewController,MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var findOnTheMapButton: UIButton!
    
    @IBOutlet weak var submitButton: UIButton!
    
    @IBOutlet weak var questionTextView: UITextView!
    
    @IBOutlet weak var answerTextView: UITextView!
    
    var newStudentLocation:StudentLocation?
    var user:UdacityUserInformation?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        answerTextView.becomeFirstResponder()

    }
    
    @IBAction func findOnTheMapTouchUpInside(sender: UIButton) {
         
        var geocoder = CLGeocoder()
        var success = true
        geocoder.geocodeAddressString(answerTextView.text, completionHandler: {(placemarks: [AnyObject]!, error: NSError!) -> Void in
            
            if let errorGeocoding = error {
                
                println(errorGeocoding.localizedDescription)
                success = false
                
            }else{
                
                if let placemark = placemarks?[0] as? CLPlacemark {
                    
                    let span = MKCoordinateSpanMake(0.05, 0.05)
                    let region = MKCoordinateRegionMake(placemark.location.coordinate, span)
                    self.mapView.setRegion(region, animated: true)
                    self.mapView.addAnnotation(MKPlacemark(placemark: placemark))
                    
                    self.newStudentLocation = StudentLocation(mapString: self.answerTextView.text)
                    self.newStudentLocation?.latitude = placemark.location.coordinate.latitude
                    self.newStudentLocation?.longitude = placemark.location.coordinate.longitude
                    
                    
                }
            }
            
        })
        
        if success {
            
            
             mapView.hidden = false
            submitButton.hidden = false
            
            questionTextView.becomeFirstResponder()
            
            questionTextView.text = "http://"
            questionTextView.backgroundColor = answerTextView.backgroundColor
            questionTextView.font = answerTextView.font
            questionTextView.textAlignment = answerTextView.textAlignment
            questionTextView.textColor = answerTextView.textColor
            questionTextView.editable = true
            questionTextView.selectable = true
            
            
            answerTextView.hidden = true
            findOnTheMapButton.hidden = true
        }
        
    }
    @IBAction func submitTouchUpInside(sender: UIButton) {
        
        if let user = user {
            
            newStudentLocation!.firstName = user.firstName
            newStudentLocation!.lastName  = user.lastName
            newStudentLocation!.uniqueKey = "\(user.uniqueKey)"
            newStudentLocation?.mediaURL = questionTextView.text
            
            StudentLocationClient.sharedInstance().putStudentLocation(newStudentLocation!) { (result, error) -> Void in
                
                if let error = error {
                    
                    println(error.localizedDescription)
                }else {
                    if result {
                        
                        let controller = self.storyboard!.instantiateViewControllerWithIdentifier("TabBarController") as! OnTheMapTabBarController
                        self.presentViewController(controller, animated: true, completion: nil)
                        
                    }
                }
                
            }
            
            
            
        }
        
        
    }
    
}