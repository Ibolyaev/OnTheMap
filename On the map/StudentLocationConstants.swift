//
//  StudentLocationConstants.swift
//  On the map
//
//  Created by Admin on 10.06.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

import Foundation
extension StudentLocationClient {
    
    // MARK: - Constants
    struct Constants {
        
        // MARK: API Key
        static let ApiKey : String = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
        static let ApplicationID : String = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        // MARK: URLs
        static let BaseURLSecure : String = "https://api.parse.com/1/classes/"
        
        
    }
    // MARK: - Methods
    struct Methods {
        
        // MARK: Account
        static let StudentLocation = "StudentLocation"
        
        
    }
    // MARK: - JSON  Keys
    struct JSONKeys {
        
        // Object
        static let ObjectId = "objectId"
        static let UniqueKey = "uniqueKey"
        static let FirstName = "firstName"
        static let LastName = "lastName"
        static let MapString = "mapString"
        static let MediaURL = "mediaURL"
        static let Latitude = "latitude"
        static let Longitude = "longitude"
        static let CreatedAt = "createdAt"
        static let UpdatedAt = "updatedAt"
        
        static let Results = "results"
        
    }
    
    
}
