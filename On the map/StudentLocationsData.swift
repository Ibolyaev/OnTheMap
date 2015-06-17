//
//  StudentLocationsData.swift
//  On the map
//
//  Created by Admin on 17.06.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

import Foundation

class StudentLocationsData: NSObject {
    
    static let sharedInstance = StudentLocationsData()
    
    var studentLocations: [StudentLocation] = [StudentLocation]()
    
    override init() {
        super.init()        
    }
    
}