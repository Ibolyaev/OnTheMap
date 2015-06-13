//
//  StudentLocationClient.swift
//  On the map
//
//  Created by Admin on 10.06.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

import Foundation

class StudentLocationClient: NSObject {
    
    /* Shared session */
    var session: NSURLSession
    
    override init() {
        session = NSURLSession.sharedSession()
        super.init()
    }
    
    func GetStudentLocations() {
        
    }
    
    
    func taskForPostMethod(method: String,  jsonBody: [String:AnyObject], completionHandler: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
        
        /*let request = NSMutableURLRequest(URL: NSURL(string: "https://api.parse.com/1/classes/StudentLocation")!)
        request.HTTPMethod = "POST"
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = "{\"uniqueKey\": \"1234\", \"firstName\": \"John\", \"lastName\": \"Doe\",\"mapString\": \"Mountain View, CA\", \"mediaURL\": \"https://udacity.com\",\"latitude\": 37.386052, \"longitude\": -122.083851}".dataUsingEncoding(NSUTF8StringEncoding)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
        if error != nil { // Handle error…
        return
        }
        println(NSString(data: data, encoding: NSUTF8StringEncoding))
        }
        task.resume()*/
        
        
        //Build the URL and configure the request */
        
        let urlString = Constants.BaseURLSecure + method
        let url = NSURL(string: urlString)!
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.addValue(Constants.ApplicationID, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(Constants.ApiKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        var jsonifyError: NSError? = nil
        request.HTTPBody = NSJSONSerialization.dataWithJSONObject(jsonBody, options: nil, error: &jsonifyError)
        /* Make the request */
        let task = session.dataTaskWithRequest(request) {data, response, downloadError in
            
            /* Parse the data and use the data (happens in completion handler) */
            if let error = downloadError {
                let newError = UdacityClient.errorForData(data, response: response, error: error)
                completionHandler(result: nil, error: downloadError)
            } else {
                //
                let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5)) /* subset response data! */
                
                StudentLocationClient.parseJSONWithCompletionHandler(newData, completionHandler: completionHandler)
            }
        }
        
        /* Start the request */
        task.resume()
        
        return task
    }
    
    func taskForGetMethod(method: String, completionHandler: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
        
        /*let request = NSMutableURLRequest(URL: NSURL(string: "https://api.parse.com/1/classes/StudentLocation")!)
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil { // Handle error...
                return
            }
            println(NSString(data: data, encoding: NSUTF8StringEncoding))
        }
        task.resume()*/

        
        
        //Build the URL and configure the request */
        
        let urlString = Constants.BaseURLSecure + method
        let url = NSURL(string: urlString)!
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "GET"
        request.addValue(Constants.ApplicationID, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(Constants.ApiKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        
        /* Make the request */
        let task = session.dataTaskWithRequest(request) {data, response, downloadError in
            
            /* Parse the data and use the data (happens in completion handler) */
            if let error = downloadError {
                let newError = StudentLocationClient.errorForData(data, response: response, error: error)
                completionHandler(result: nil, error: downloadError)
            } else {
                
                StudentLocationClient.parseJSONWithCompletionHandler(data, completionHandler: completionHandler)
            }
        }
        
        /* Start the request */
        task.resume()
        
        return task
    }
    
    /* Helper: Given a response with error, see if a status_message is returned, otherwise return the previous error */
    class func errorForData(data: NSData?, response: NSURLResponse?, error: NSError) -> NSError {
        
        if let parsedResult = NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments, error: nil) as? [String : AnyObject] {
            
            return NSError(domain: "StudentLocationClient Error", code: 1, userInfo: nil)
        }
        
        return error
    }

    /* Helper: Given raw JSON, return a usable Foundation object */
    class func parseJSONWithCompletionHandler(data: NSData, completionHandler: (result: AnyObject!, error: NSError?) -> Void) {
        
        var parsingError: NSError? = nil
        
        let parsedResult: AnyObject? = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: &parsingError)
        
        if let error = parsingError {
            completionHandler(result: nil, error: error)
        } else {
            completionHandler(result: parsedResult, error: nil)
        }
    }
    
    // MARK: - Shared Instance
    
    class func sharedInstance() -> StudentLocationClient {
        
        struct Singleton {
            static var sharedInstance = StudentLocationClient()
        }
        
        return Singleton.sharedInstance
    }

    
}
