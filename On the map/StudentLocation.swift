//
//  StudentLocation.swift
//  On the map
//
//  Created by Admin on 10.06.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

import Foundation

class StudentLocation: NSObject {
    
    var objectId  :String = ""
    var uniqueKey :String = ""
    var firstName :String = ""
    var lastName  :String = ""
    var mapString :String = ""
    var mediaURL  :String = ""
    var latitude  :NSNumber = 0
    var longitude :NSNumber = 0
    var createdAt :NSDate = NSDate()
    var updatedAt :NSDate = NSDate()
    
    
    init(dictionary: [String : AnyObject]) {
        
        objectId  = dictionary[StudentLocationClient.JSONKeys.ObjectId] as! String
        uniqueKey = dictionary[StudentLocationClient.JSONKeys.UniqueKey] as! String
        firstName = dictionary[StudentLocationClient.JSONKeys.FirstName] as! String
        lastName  = dictionary[StudentLocationClient.JSONKeys.LastName] as! String
        mapString = dictionary[StudentLocationClient.JSONKeys.MapString] as! String
        mediaURL  = dictionary[StudentLocationClient.JSONKeys.MediaURL] as! String
        latitude  = dictionary[StudentLocationClient.JSONKeys.Latitude] as! NSNumber
        longitude = dictionary[StudentLocationClient.JSONKeys.Longitude] as! NSNumber
        
    }
    
    init(mapString:String){
        self.mapString = mapString
    }
    
    
    
    func getJSONBody() -> NSDictionary {
        var result = [
            StudentLocationClient.JSONKeys.UniqueKey:uniqueKey,
            StudentLocationClient.JSONKeys.FirstName:firstName,
            StudentLocationClient.JSONKeys.LastName:lastName,
            StudentLocationClient.JSONKeys.MapString:mapString,
            StudentLocationClient.JSONKeys.MediaURL:mediaURL,
            StudentLocationClient.JSONKeys.Latitude:latitude,
            StudentLocationClient.JSONKeys.Longitude:longitude
        ]
        return result
    }
    
    /* Helper: Given an array of dictionaries, convert them to an array of StudentLocation objects */
    static func studentLocationsFromResults(results: [[String : AnyObject]]) -> [StudentLocation] {
        var locations = [StudentLocation]()
        
        for result in results {
            locations.append(StudentLocation(dictionary: result))
        }
        
        return locations
    }

}

