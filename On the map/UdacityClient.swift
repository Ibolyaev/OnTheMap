//
//  UdacityClient.swift
//  On the map
//
//  Created by Admin on 09.06.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

import Foundation

class UdacityClient: NSObject {
    
    /* Shared session */
    var session: NSURLSession
    
    override init() {
        session = NSURLSession.sharedSession()
        super.init()
    }
    
    func taskForPostMethod(method: String,  jsonBody: [String:AnyObject], completionHandler: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
        
        //Build the URL and configure the request */
        
        let urlString = Constants.BaseURLSecure + method
        let url = NSURL(string: urlString)!
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
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
                
                UdacityClient.parseJSONWithCompletionHandler(newData, completionHandler: completionHandler)
            }
        }
        
        /* Start the request */
        task.resume()
        
        return task
    }
    
    func taskForGetMethod(method: String, completionHandler: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
        
        //Build the URL and configure the request */
        
        let urlString = Constants.BaseURLSecure + method
        let url = NSURL(string: urlString)!
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "GET"
        
        /* Make the request */
        let task = session.dataTaskWithRequest(request) {data, response, downloadError in
            
            /* Parse the data and use the data (happens in completion handler) */
            if let error = downloadError {
                let newError = UdacityClient.errorForData(data, response: response, error: error)
                completionHandler(result: nil, error: downloadError)
            } else {
                //
                let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5)) /* subset response data! */
                
                UdacityClient.parseJSONWithCompletionHandler(newData, completionHandler: completionHandler)
            }
        }
        
        /* Start the request */
        task.resume()
        
        return task
    }

    func getUserInformation (uniqueKey: Int, completionHandler:(result: UdacityUserInformation?,errorString:String?) -> Void) {
        
        var method = Methods.Users
        
        method = "\(method)/\(uniqueKey)"
        
        taskForGetMethod(method, completionHandler: { (result, error) -> Void in
            
            if let error = error {
                
                completionHandler(result: nil, errorString: "Error during get user info")
            }else {
                
                if let paresedResult = result as? NSDictionary {
                    
                    let userInfo = paresedResult.valueForKey(JSONResponseKeys.User) as? NSDictionary
                    
                   completionHandler(result: UdacityUserInformation(dictionary: userInfo as! [String : AnyObject],uniqueKey: uniqueKey), errorString: "")
                    
                }
            }
        })
        
    }
    
    
    func authenticateWithUdacityApi(login: String,password: String, completionHandler: (success: Bool, uniqueKey: Int, errorString: String?) -> Void) {
        
        let jsonBody = [JSONBodyKeys.Udacity:
            [JSONBodyKeys.Username:login,
                JSONBodyKeys.Password: password]]
        
        taskForPostMethod(Methods.Session, jsonBody: jsonBody) { (result, error) -> Void in
            
            if let paresedResult = result as? NSDictionary {
                
                if let someError = error {
                    completionHandler(success: false, uniqueKey: 0, errorString:"Error during authentication")
                }else{
                    
                    if paresedResult.valueForKey(JSONResponseKeys.Error) != nil {
                        completionHandler(success: false,uniqueKey: 0, errorString: paresedResult.valueForKey(JSONResponseKeys.Error) as? String)
                    } else {
                        
                        //success
                        if let accountInfo = paresedResult.valueForKey(JSONResponseKeys.Account) as? NSDictionary {
                            
                            let key = accountInfo.valueForKey(JSONResponseKeys.Key) as! String
                            
                            
                            
                            completionHandler(success: accountInfo.valueForKey(JSONResponseKeys.Registered) as! Bool,uniqueKey: key.toInt()!, errorString: "")
                            
                        }
                        
                        
                    }
                }
                
            }
            
            
        }
        
        
    }
    
    
    /* Helper: Given a response with error, see if a status_message is returned, otherwise return the previous error */
    class func errorForData(data: NSData?, response: NSURLResponse?, error: NSError) -> NSError {
        
        if let parsedResult = NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments, error: nil) as? [String : AnyObject] {
            
            return NSError(domain: "UdacityClient Error", code: 1, userInfo: nil)
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
    
    class func sharedInstance() -> UdacityClient {
        
        struct Singleton {
            static var sharedInstance = UdacityClient()
        }
        
        return Singleton.sharedInstance
    }


}