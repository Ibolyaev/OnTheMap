//
//  UdacityConstants.swift
//  On the map
//
//  Created by Admin on 09.06.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

extension UdacityClient {
    
    // MARK: - Constants
    struct Constants {
        
        // MARK: API Key
        //static let ApiKey : String = "528f1784929d7509b9e4a7240b62afb3"
        
        // MARK: URLs
         static let BaseURLSecure : String = "https://www.udacity.com/api/"
        
        
    }
    // MARK: - Methods
    struct Methods {
        
        // MARK: Account
        static let Session = "session"
        static let Users = "users"
        
    }
    // MARK: - JSON Body Keys
    struct JSONBodyKeys {
        
        static let Username = "username"
        static let Password = "password"
        static let Udacity = "udacity"
        
        
    }
    
    // MARK: - JSON Response Keys
    struct JSONResponseKeys {
        
        // MARK: Authorization
        static let Status = "status"
        static let Error = "error"
        
        static let Account = "account"
        static let Registered = "registered"
        static let Key = "key"
        static let Session = "session"
        static let Id = "id"
    }

}
