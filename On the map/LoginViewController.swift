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
    
    var user:UdacityUserInformation?
    
    var keyboardAdjusted = false
    var lastKeyboardOffset : CGFloat = 0.0
    var tapRecognizer: UITapGestureRecognizer? = nil
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBAction func login(sender: UIButton) {
        
        loginWithUdacityClient()
     }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /* Configure tap recognizer */
        tapRecognizer = UITapGestureRecognizer(target: self, action: "handleSingleTap:")
        tapRecognizer?.numberOfTapsRequired = 1
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.addKeyboardDismissRecognizer()
        self.subscribeToKeyboardNotifications()
        
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.removeKeyboardDismissRecognizer()
        self.unsubscribeToKeyboardNotifications()
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
    
    

    func loginWithUdacityClient() {
        
        UdacityClient.sharedInstance().authenticateWithUdacityApi(emailTextField.text, password: passwordTextField.text) { (success,uniqueKey, error) -> Void in
            
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
            
            var controller = self.storyboard!.instantiateViewControllerWithIdentifier("OnTheMapTabBarController") as! OnTheMapTabBarController
            UdacityClient.user = user
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

extension LoginViewController {
    
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        
        if keyboardAdjusted == false {
            lastKeyboardOffset = getKeyboardHeight(notification) / 2
            self.view.superview?.frame.origin.y -= lastKeyboardOffset
            keyboardAdjusted = true
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        
        if keyboardAdjusted == true {
            self.view.superview?.frame.origin.y += lastKeyboardOffset
            keyboardAdjusted = false
        }
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.CGRectValue().height
    }
}


