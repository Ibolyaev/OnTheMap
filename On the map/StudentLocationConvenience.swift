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

    func putStudentLocation(newStudentLocation: StudentLocation, completionHandler:( result:Bool, error: NSError?) -> Void) {
        
        var mutableMethod : String = Methods.StudentLocation
        
        
        println(newStudentLocation.getJSONBody())
        
        taskForPostMethod(mutableMethod, jsonBody: newStudentLocation.getJSONBody() as! [String : AnyObject]) { (JSONResult, error) -> Void in
            
            if let error = error {
                completionHandler(result: false, error: error)
            } else {
                
                if let result = JSONResult.valueForKey(JSONKeys.ObjectId) as? String {
                    completionHandler(result: true, error: nil)
                }
                
            }
            
            
        }
        
    }
    
}