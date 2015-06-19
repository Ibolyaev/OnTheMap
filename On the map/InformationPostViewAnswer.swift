//
//  InformationPostViewAnswer.swift
//  On the map
//
//  Created by Admin on 18.06.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class InformationPostViewAnswer: UIViewController, MKMapViewDelegate {
    
    var keyboardAdjusted = false
    var lastKeyboardOffset : CGFloat = 0.0
    var tapRecognizer: UITapGestureRecognizer? = nil
    
    @IBOutlet weak var mediaURLTextField: UITextView!
    
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

    
    @IBAction func submitTouchUpInside(sender: UIButton) {
        
        
        if validateUrl(mediaURLTextField.text) {
            
            
            var tabBarController = self.tabBarController as! InformationTabBarController
            let newStudentLocation = tabBarController.newStudentLocation
            
            let user = UdacityClient.user
            
            if let user = user {
                
                newStudentLocation!.firstName = user.firstName
                newStudentLocation!.lastName  = user.lastName
                newStudentLocation!.uniqueKey = "\(user.uniqueKey)"
                newStudentLocation!.mediaURL = mediaURLTextField.text
                
                StudentLocationClient.sharedInstance().putStudentLocation(newStudentLocation!) { (result, error) -> Void in
                    
                    if let error = error {
                        
                        self.displayError(error.localizedDescription, titleError: "Failed to save student location")
                    }else {
                        if result {
                            dispatch_async(dispatch_get_main_queue()) {
                                self.openMainTabBar()
                            }
                            
                            
                        }
                    }
                    
                }
                
                
                
            }else{
                self.displayError("No user information", titleError: "Failed to submit student location")
            }
        }else{
            self.displayError("Not valid URL", titleError: "Failed to submit student location")
        }
        
    }
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        
        self.addKeyboardDismissRecognizer()
        
        
        var tabBarController = self.tabBarController as! InformationTabBarController
        let placemark = tabBarController.placemark
             
        if let placemark = placemark {
            
            let span = MKCoordinateSpanMake(0.05, 0.05)
            let region = MKCoordinateRegionMake(placemark.location.coordinate, span)
            self.mapView.setRegion(region, animated: true)
            self.mapView.addAnnotation(MKPlacemark(placemark: placemark))
            
        }
        
        mediaURLTextField.text = "http://"
        mediaURLTextField.isFirstResponder()
        
        //to vertically center input text NSKeyValueObservingOptionNew
        mediaURLTextField.addObserver(self, forKeyPath: "contentSize", options: NSKeyValueObservingOptions.New, context: nil)
        
        
        
    }
   
    func openMainTabBar() {
        let controller = self.storyboard!.instantiateViewControllerWithIdentifier("OnTheMapTabBarController") as! OnTheMapTabBarController
        self.presentViewController(controller, animated: true, completion: nil)
    }
    
    override func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject : AnyObject], context: UnsafeMutablePointer<Void>) {
        let txtview = object as! UITextView
        var topoffset = (txtview.bounds.size.height - txtview.contentSize.height * txtview.zoomScale)/2.0
        topoffset = ( topoffset < 0.0 ? 0.0 : topoffset )
        //txtview.contentOffset = (CGPoint){.x = 0;, .y = -topoffset};
        txtview.contentOffset = CGPoint(x: 0, y: -topoffset)
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
    //Regular expression used for validating submitted URLs.
    func validateUrl(url: String) -> Bool {
        let pattern = "^(https?:\\/\\/)([a-zA-Z0-9_\\-~]+\\.)+[a-zA-Z0-9_\\-~\\/\\.]+$"
        if let match = url.rangeOfString(pattern, options: .RegularExpressionSearch){
            return true
        }
        return false
    }

    
}
