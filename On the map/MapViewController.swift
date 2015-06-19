//
//  MapViewController.swift
//  On the map
//
//  Created by Admin on 10.06.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate,OnTheMapDelegate  {
    
    @IBOutlet weak var refreshButton: UIBarButtonItem!
    @IBOutlet weak var mapView: MKMapView!
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        refreshButton.target = self
        refreshButton.action = "refresh:"
        
        OnTheMapTabBarController.addNavigationBarButtons(self)
        
        loadLocations()
   
    }
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
      
    }
    
    func refresh(sender: UIBarButtonItem) {
        loadLocations()
    }
    
    func addLocation(sender: UIBarButtonItem){
        
        let controller = self.storyboard!.instantiateViewControllerWithIdentifier("InformationPostViewNavController") as! UINavigationController
        
        self.presentViewController(controller, animated: true, completion: nil)
        
    }
    
    func loadLocations() {
        
        StudentLocationClient.sharedInstance().getStudentLocations { (result, error) -> Void in
            
            if let studentLocations = result {
                
                StudentLocationsData.sharedInstance.studentLocations = studentLocations
                dispatch_async(dispatch_get_main_queue()) {
                    self.updateMapView()
                }
  
            }else{
                
                if let error = error {
                    self.displayError(error.localizedDescription,titleError: "Failed to load locations")
                }
                
            }
            
        }
 
    }
    
    func logOut(sender: UIBarButtonItem) {
        
        UdacityClient.sharedInstance().logOutWithUdacityApi { (success, error) -> Void in
            
            if success {
                
                dispatch_async(dispatch_get_main_queue()) {
                    self.openLoginView()
                }
                
            }else{
                if let error = error {
                    self.displayError(error.localizedDescription,titleError: "Failed to logout")
                    
                }
            }
         }
    }
    
    func openLoginView() {
        
        let tabBarcontroller = self.tabBarController as! OnTheMapTabBarController
        
        var controller = self.storyboard!.instantiateViewControllerWithIdentifier("LoginViewController") as! UIViewController
        
        self.presentViewController(controller, animated: true, completion: nil)
    }
    
    // When user taps on the disclosure button perform a segue to Safari app
    func mapView(mapView: MKMapView!, annotationView view: MKAnnotationView!, calloutAccessoryControlTapped control: UIControl!) {
        if control == view.rightCalloutAccessoryView{
            
            var url = NSURL(string: view.annotation.subtitle!)
            UIApplication.sharedApplication().openURL(url!)
        }
    }
    
    // Here we add disclosure button inside annotation window
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        
       
        if annotation is MKUserLocation {
            
            return nil
        }
        
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.animatesDrop = true
        }
        
        var button = UIButton.buttonWithType(UIButtonType.DetailDisclosure) as! UIButton // button with info sign in it
        
        pinView?.rightCalloutAccessoryView = button
        
        
        return pinView
    }
    

    func updateMapView() {
        
        mapView.removeAnnotations(mapView.annotations)
        
        for el in StudentLocationsData.sharedInstance.studentLocations {
            addNewLocationOnMap(el)
        }
        
    }

    func addNewLocationOnMap(student: StudentLocation){
        
        let location = CLLocationCoordinate2D(
            latitude: student.latitude.doubleValue,
            longitude: student.longitude.doubleValue
        )
        // 2
        //let span = MKCoordinateSpanMake(0.05, 0.05)
        //let region = MKCoordinateRegion(center: location, span: span)
        //mapView.setRegion(region, animated: true)
        
        //3
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        annotation.title = "\(student.firstName) \(student.lastName)"
        annotation.subtitle = student.mediaURL
        
        mapView.addAnnotation(annotation)

    }
    
    func displayError(errorString: String?,titleError: String?) {
        dispatch_async(dispatch_get_main_queue(), {
            if let errorString = errorString {
                
                let alertController = UIAlertController(title: titleError, message: "\(errorString)", preferredStyle: .Alert)
                
                //let tryAgainAction = UIAlertAction(title: "Try again?", style: .Cancel) { (action) in
                    //self.loginWithUdacityClient()
                //}
                //alertController.addAction(tryAgainAction)
                
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
