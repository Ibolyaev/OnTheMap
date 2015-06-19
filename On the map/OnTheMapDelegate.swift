//
//  OnTheMapDelegate.swift
//  On the map
//
//  Created by Admin on 18.06.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

import Foundation
import UIKit

protocol OnTheMapDelegate {
    func loadLocations()
    func addLocation(sender: UIBarButtonItem)
    func logOut(sender: UIBarButtonItem)
    func displayError(errorString: String?,titleError: String?)
}
