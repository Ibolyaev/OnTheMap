//
//  InformationPostView.swift
//  On the map
//
//  Created by Admin on 18.06.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

import Foundation
import Foundation
import UIKit

class InformationPostView: UIViewController {
    
    @IBAction func cancelButtonPressed(sender: UIBarButtonItem) {
        
        var controller = self.storyboard!.instantiateViewControllerWithIdentifier("TabBarController") as! OnTheMapTabBarController
        
        self.presentViewController(controller, animated: true, completion: nil)
    }
    
}