//
//  ParseClient.swift
//  OnTheMap
//
//  Created by Lawrence Tan on 3/1/16.
//  Copyright © 2016 Lawrence Tan. All rights reserved.
//

import Foundation
import MapKit

// MARK: - ParseClient: NSObject

class ParseClient: NSObject {

    // MARK: Properties
    
    /* Shared session */
    var session: NSURLSession
    
    /* Authentication state */
    var sessionID : String? = nil
    var userID : Int? = nil
    
    /* Authenticated Values */
    var uniqueKey : String? = nil
    
    var isUpdate : Bool? = false
    var objectId : String? = nil
    
    var updatedLatitude : CLLocationDegrees?
    var updatedLongitude : CLLocationDegrees?
    
    // MARK: Initializers
    
    override init() {
        session = NSURLSession.sharedSession()
        super.init()
    }
    
    // MARK: GET
    
    func taskForGETMethod(method: String, parameters: [String : AnyObject], completionHandler: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
        
        /* 2/3. Build the URL and configure the request */
        let urlString = Constants.BaseURLSecure + method + ParseClient.escapedParameters(parameters)
        let url = NSURL(string: urlString)!
        let request = NSMutableURLRequest(URL: url)
        request.addValue(Constants.ApplicationKey, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(Constants.RESTKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        
        /* 4. Make the request */
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                print("There was an error with your request: \(error)")
                completionHandler(result: nil, error: error)
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                if let response = response as? NSHTTPURLResponse {
                    print("Your request returned an invalid response! Status code: \(response.statusCode)!")
                } else if let response = response {
                    print("Your request returned an invalid response! Response: \(response)!")
                } else {
                    print("Your request returned an invalid response!")
                }
                completionHandler(result: nil, error: NSError(domain: "taskForGETMethod parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Something went wrong, please try again."]))
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                print("No data was returned by the request!")
                completionHandler(result: nil, error: NSError(domain: "taskForGETMethod parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Something went wrong, please try again."]))
                return
            }
            
            /* 5/6. Parse the data and use the data (happens in completion handler) */
            ParseClient.parseJSONWithCompletionHandler(data, completionHandler: completionHandler)
        }
        
        /* 7. Start the request */
        task.resume()
        
        return task
    }
    
    // MARK: POST
    
    func taskForPOSTMethod(method: String, parameters: [String : AnyObject], completionHandler: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
        
        /* 2/3. Build the URL and configure the request */
        let urlString = Constants.BaseURLSecure + method
        let url = NSURL(string: urlString)!
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.addValue(Constants.ApplicationKey, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(Constants.RESTKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let paramString = "{\"uniqueKey\": \"\(parameters[ParseClient.JSONResponseKeys.UniqueKey]!)\", \"firstName\": \"\(parameters[ParseClient.JSONResponseKeys.FirstName]!)\", \"lastName\": \"\(parameters[ParseClient.JSONResponseKeys.LastName]!)\", \"mapString\": \"\(parameters[ParseClient.JSONResponseKeys.MapString]!)\", \"mediaURL\": \"\(parameters[ParseClient.JSONResponseKeys.MediaURL]!)\", \"latitude\": \(parameters[ParseClient.JSONResponseKeys.Latitude]!), \"longitude\": \(parameters[ParseClient.JSONResponseKeys.Longitude]!)}"
        
        request.HTTPBody = paramString.dataUsingEncoding(NSUTF8StringEncoding)
        
        /* 4. Make the request */
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                print("There was an error with your request: \(error)")
                completionHandler(result: nil, error: error)
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                if let response = response as? NSHTTPURLResponse {
                    print("Your request returned an invalid response! Status code: \(response.statusCode)!")
                } else if let response = response {
                    print("Your request returned an invalid response! Response: \(response)!")
                } else {
                    print("Your request returned an invalid response!")
                }
                completionHandler(result: nil, error: NSError(domain: "taskForPOSTMethod parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Something went wrong, please try again."]))
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                print("No data was returned by the request!")
                completionHandler(result: nil, error: NSError(domain: "taskForPOSTMethod parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Something went wrong, please try again."]))
                return
            }
            
            /* 5/6. Parse the data and use the data (happens in completion handler) */
            if urlString.containsString("parse"){
                UdacityClient.parseNormalJSONWithCompletionHandler(data, completionHandler: completionHandler)
            }else{
                UdacityClient.parseJSONWithCompletionHandler(data, completionHandler: completionHandler)
            }
            
            return
        }
        
        /* 7. Start the request */
        task.resume()
        
        return task
    }
    
    // MARK: PUT
    
    func taskForPUTMethod(method: String, parameters: [String : AnyObject], completionHandler: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
        
        /* 2/3. Build the URL and configure the request */
        let urlString = Constants.BaseURLSecure + method + "/" + ParseClient.sharedInstance().objectId!
        let url = NSURL(string: urlString)!
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "PUT"
        request.addValue(Constants.ApplicationKey, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(Constants.RESTKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let paramString = "{\"uniqueKey\": \"\(parameters[ParseClient.JSONResponseKeys.UniqueKey]!)\", \"firstName\": \"\(parameters[ParseClient.JSONResponseKeys.FirstName]!)\", \"lastName\": \"\(parameters[ParseClient.JSONResponseKeys.LastName]!)\", \"mapString\": \"\(parameters[ParseClient.JSONResponseKeys.MapString]!)\", \"mediaURL\": \"\(parameters[ParseClient.JSONResponseKeys.MediaURL]!)\", \"latitude\": \(parameters[ParseClient.JSONResponseKeys.Latitude]!), \"longitude\": \(parameters[ParseClient.JSONResponseKeys.Longitude]!)}"
        
        request.HTTPBody = paramString.dataUsingEncoding(NSUTF8StringEncoding)
        
        /* 4. Make the request */
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                print("There was an error with your request: \(error)")
                completionHandler(result: nil, error: error)
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                if let response = response as? NSHTTPURLResponse {
                    print("Your request returned an invalid response! Status code: \(response.statusCode)!")
                } else if let response = response {
                    print("Your request returned an invalid response! Response: \(response)!")
                } else {
                    print("Your request returned an invalid response!")
                }
                completionHandler(result: nil, error: NSError(domain: "taskForPUTMethod parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Something went wrong, please try again."]))
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                print("No data was returned by the request!")
                completionHandler(result: nil, error: NSError(domain: "taskForPUTMethod parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Something went wrong, please try again."]))
                return
            }
            
            /* 5/6. Parse the data and use the data (happens in completion handler) */
            if urlString.containsString("parse"){
                UdacityClient.parseNormalJSONWithCompletionHandler(data, completionHandler: completionHandler)
            }else{
                UdacityClient.parseJSONWithCompletionHandler(data, completionHandler: completionHandler)
            }
            
            return
        }
        
        /* 7. Start the request */
        task.resume()
        
        return task
    }
    
    
    // MARK: Helpers
    
    /* Helper: Substitute the key for the value that is contained within the method name */
    class func subtituteKeyInMethod(method: String, key: String, value: String) -> String? {
        if method.rangeOfString("{\(key)}") != nil {
            return method.stringByReplacingOccurrencesOfString("{\(key)}", withString: value)
        } else {
            return nil
        }
    }
    
    /* Helper: Given raw JSON, return a usable Foundation object */
    class func parseJSONWithCompletionHandler(data: NSData, completionHandler: (result: AnyObject!, error: NSError?) -> Void) {
        
        var parsedResult: AnyObject!
        do {
            parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
        } catch {
            let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(data)'"]
            completionHandler(result: nil, error: NSError(domain: "parseJSONWithCompletionHandler", code: 1, userInfo: userInfo))
        }
        completionHandler(result: parsedResult, error: nil)
    }
    
    /* Helper function: Given a dictionary of parameters, convert to a string for a url */
    class func escapedParameters(parameters: [String : AnyObject]) -> String {
        
        var urlVars = [String]()
        
        for (key, value) in parameters {
            
            /* Make sure that it is a string value */
            let stringValue = "\(value)"
            
            /* Escape it */
            let escapedValue = stringValue.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
            
            /* Append it */
            urlVars += [key + "=" + "\(escapedValue!)"]
            
        }
        
        return (!urlVars.isEmpty ? "?" : "") + urlVars.joinWithSeparator("&")
    }
    
    // MARK: Shared Instance
    
    class func sharedInstance() -> ParseClient {
        
        struct Singleton {
            static var sharedInstance = ParseClient()
        }
        
        return Singleton.sharedInstance
    }
    
    
}
