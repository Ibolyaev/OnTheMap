//
//  InformationPostViewQuestion.swift
//  On the map
//
//  Created by Admin on 18.06.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class InformationPostViewQuestion: UIViewController {
    
    @IBOutlet weak var answerTextField: UITextView!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var newStudentLocation: StudentLocation?
    var placemark:CLPlacemark?
    
    var keyboardAdjusted = false
    var lastKeyboardOffset : CGFloat = 0.0
    var tapRecognizer: UITapGestureRecognizer? = nil
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        
        self.addKeyboardDismissRecognizer()
       
        
        answerTextField.isFirstResponder()
        self.tabBarController?.tabBar.hidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /* Configure tap recognizer */
        tapRecognizer = UITapGestureRecognizer(target: self, action: "handleSingleTap:")
        tapRecognizer?.numberOfTapsRequired = 1
    }
    
    
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.removeKeyboardDismissRecognizer()
        
    }
    
    // MARK: - Keyboard Fixes
    
    func addKeyboardDismissRecognizer() {
        self.view.addGestureRecognizer(tapRecognizer!)
    }
    
    func removeKeyboardDismissRecognizer() {
        self.view.removeGestureRecognizer(tapRecognizer!)
    }
    
    func handleSingleTap(recognizer: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }

    
    @IBAction func findOnMap(sender: UIButton) {
        
        if answerTextField.text.isEmpty {
            
            self.displayError("Empty address",titleError:"Failed to geocode adress")
            
        }else{
            
            
            var geocoder = CLGeocoder()
            
            activityIndicator.hidden = false
            activityIndicator.startAnimating()
            activityIndicator.hidesWhenStopped = true
            geocoder.geocodeAddressString(answerTextField.text, completionHandler: {(placemarks: [AnyObject]!, error: NSError!) -> Void in
                
                if let errorGeocoding = error {
                    
                    self.displayError(errorGeocoding.localizedDescription,titleError:"Failed to geocode adress")
                    
                    
                }else{
                    
                    if let placemark = placemarks?[0] as? CLPlacemark {
                        
                        var tabBarController = self.tabBarController as! InformationTabBarController
                        
                        tabBarController.placemark = placemark
                        
                        tabBarController.newStudentLocation = StudentLocation(mapString: self.answerTextField.text)
                        tabBarController.newStudentLocation?.latitude = placemark.location.coordinate.latitude
                        tabBarController.newStudentLocation?.longitude = placemark.location.coordinate.longitude
                        
                        self.tabBarController?.selectedIndex = 1
                        
                    }
                }
                self.activityIndicator.stopAnimating()
            })
            
        }
    }
    func displayError(errorString: String?,titleError: String?) {
        dispatch_async(dispatch_get_main_queue(), {
            if let errorString = errorString {
                
                let alertController = UIAlertController(title: titleError, message: "\(errorString)", preferredStyle: .Alert)
                
                
                let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
                    // ...
                }
                alertController.addAction(OKAction)
                
                self.presentViewController(alertController, animated: true) {
                    // ...
                }
            }
        })
    }

    
}


