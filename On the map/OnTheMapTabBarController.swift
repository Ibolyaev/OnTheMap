//
//  OnTheMapTabBarController.swift
//  On the map
//
//  Created by Admin on 16.06.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

import Foundation
import UIKit

class OnTheMapTabBarController: UITabBarController {
    
    
    
    class func addNavigationBarButtons(viewController: UIViewController){
        
        //viewController.navigationItem.leftItemsSupplementBackButton = true
        
        let addButton = UIBarButtonItem(image: UIImage(named: "pin"), style: UIBarButtonItemStyle.Plain, target: viewController, action: "addLocation:")
        
        let logoutButton = UIBarButtonItem(title: "Logout", style: UIBarButtonItemStyle.Plain, target: viewController, action: "logOut:")
        
        viewController.navigationItem.rightBarButtonItems?.append(addButton)
        viewController.navigationItem.setLeftBarButtonItem(logoutButton, animated: false)
    }
    
}