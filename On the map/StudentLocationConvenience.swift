//
//  StudentLocationConvenience.swift
//  On the map
//
//  Created by Admin on 11.06.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

import Foundation

extension StudentLocationClient {

    func getStudentLocations(completionHandler: (result: [StudentLocation]?, error: NSError?) -> Void) {
        
        
        var mutableMethod : String = Methods.StudentLocation
        
        
        /* Make the request */
        taskForGetMethod(mutableMethod) { JSONResult, error in
            
            /* Send the desired value(s) to completion handler */
            if let error = error {
                completionHandler(result: nil, error: error)
            } else {
                
                if let results = JSONResult.valueForKey(StudentLocationClient.JSONKeys.Results) as? [[String : AnyObject]] {
                    
                    var studentLocations = StudentLocation.studentLocationsFromResults(results)
                    
                    completionHandler(result: studentLocations, error: nil)
                } else {
                    completionHandler(result: nil, error: NSError(domain: "getStudentLocations parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse getStudentLocations"]))
                }
            }
        }
    }

    
    
}