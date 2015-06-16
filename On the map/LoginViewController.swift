//
//  LoginViewController.swift
//  On the map
//
//  Created by Admin on 09.06.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

import Foundation
import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var debugTextLabel: UILabel!
    
    @IBAction func login(sender: UIButton) {
        
        UdacityClient.sharedInstance().authenticateWithUdacityApi("ibolyaev@gmail.com", password: "Roodler2013") { (success,uniqueKey, errorString) -> Void in
            
            if success {
                
                UdacityClient.sharedInstance().getUserInformation(uniqueKey, completionHandler: { (result, errorString) -> Void in
                    
                    if let userInformation = result  {
                        self.completeLogin(userInformation)
                    }else{
                        println(errorString)
                    }
                    
                })
                
                
                
            } else {
                self.displayError(errorString)
            }

            
        }
   
    }
    
    func completeLogin(user:UdacityUserInformation) {
        dispatch_async(dispatch_get_main_queue(), {
            self.debugTextLabel.text = ""
            var controller = self.storyboard!.instantiateViewControllerWithIdentifier("TabBarController") as! OnTheMapTabBarController
            controller.user = user
            self.presentViewController(controller, animated: true, completion: nil)
        })
    }
    
    func displayError(errorString: String?) {
        dispatch_async(dispatch_get_main_queue(), {
            if let errorString = errorString {
                self.debugTextLabel.text = errorString
            }
        })
    }
    

    
}
