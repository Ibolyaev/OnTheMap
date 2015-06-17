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
    
    
    
    @IBAction func login(sender: UIButton) {
        
        loginWithUdacityClient()
        
    }
    
    func loginWithUdacityClient() {
        
        UdacityClient.sharedInstance().authenticateWithUdacityApi("ibolyaev@gmail.com", password: "Roodler2013") { (success,uniqueKey, error) -> Void in
            
            if success {
                
                UdacityClient.sharedInstance().getUserInformation(uniqueKey, completionHandler: { (result, error) -> Void in
                    
                    if let userInformation = result  {
                        self.completeLogin(userInformation)
                    }else{
                        if let error = error {
                            
                            self.displayError(error.localizedDescription,titleError: "Login Failed")
                        }
                        
                    }
                    
                })
                
                
                
            } else {
                if let error = error {
                    
                    self.displayError(error.localizedDescription,titleError: "Login Failed")
                }
            }
            
            
        }

    }
    
    func completeLogin(user:UdacityUserInformation) {
        dispatch_async(dispatch_get_main_queue(), {
            
            var controller = self.storyboard!.instantiateViewControllerWithIdentifier("TabBarController") as! OnTheMapTabBarController
            controller.user = user
            self.presentViewController(controller, animated: true, completion: nil)
        })
    }
    
    func displayError(errorString: String?,titleError: String?) {
        dispatch_async(dispatch_get_main_queue(), {
            if let errorString = errorString {
                
                let alertController = UIAlertController(title: titleError, message: "\(errorString)", preferredStyle: .Alert)
                
                let tryAgainAction = UIAlertAction(title: "Try again?", style: .Cancel) { (action) in
                    self.loginWithUdacityClient()
                }
                alertController.addAction(tryAgainAction)
                
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
