//
//  UdacityUserInformation.swift
//  On the map
//
//  Created by Admin on 16.06.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

import Foundation

class UdacityUserInformation: NSObject {
    
    let uniqueKey:Int
    let lastName: String
    let firstName: String
    
    init(dictionary: [String : AnyObject],uniqueKey:Int) {
        
        self.uniqueKey  = uniqueKey
        lastName   = dictionary[UdacityClient.JSONResponseKeys.LastName] as! String
        firstName  = dictionary[UdacityClient.JSONResponseKeys.FirstName] as! String
    
    }
}
