//
//  ParseConvenience.swift
//  OnTheMap
//
//  Created by Lawrence Tan on 3/1/16.
//  Copyright © 2016 Lawrence Tan. All rights reserved.
//

import UIKit
import Foundation

// MARK: - ParseClient (Convenient Resource Methods)

extension ParseClient {
    
    // MARK: GET Convenience Methods
    
    func getStudentLocations(completionHandler: (result: Bool?, error: NSError?) -> Void) {
        
        /* 1. Specify parameters, method (if has {key}), and HTTP body (if POST) */
        let parameters = ["limit": 100, "order": "-updatedAt"]
        let mutableMethod : String = Methods.StudentLocation
        
        /* 2. Make the request */
        taskForGETMethod(mutableMethod, parameters: parameters) { JSONResult, error in
            
            /* 3. Send the desired value(s) to completion handler */
            if let error = error {
                completionHandler(result: nil, error: error)
            } else {
                if JSONResult != nil {
                    if let results = JSONResult[ParseClient.JSONResponseKeys.StudentLocationsResults] as? [[String : AnyObject]] {
                        StudentLocationsClient.sharedInstance.studentLocations = StudentLocation.locationsFromResults(results)
                        completionHandler(result: true, error: nil)
                    } else {
                        completionHandler(result: nil, error: NSError(domain: "getStudentLocations parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse getStudentLocations"]))
                    }
                }else{
                    completionHandler(result: nil, error: NSError(domain: "getStudentLocations parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse getStudentLocations"]))
                }
            }
        }
    }
    
    func submitLocation(firstName: String?, lastName: String?, mapString: String?, mediaURL: String?, latitude: Double?, longitude: Double?, completionHandler: (result: Bool?, error: NSError?) -> Void) {
        
        let mutableMethod = ParseClient.Methods.StudentLocation
        let parameters = ["uniqueKey": UdacityClient.sharedInstance().uniqueKey!, "firstName": firstName!,
        "lastName": lastName!, "mapString": mapString!, "mediaURL": mediaURL!, "latitude": latitude!, "longitude": longitude!]
        
        /* 2. Make the request */
        taskForPOSTMethod(mutableMethod, parameters: parameters as! [String : AnyObject]) { JSONResult, error in
            
            /* 3. Send the desired value(s) to completion handler */
            if let error = error {
                completionHandler(result: nil, error: error)
            } else {
                
                //let typeLongName = _stdlib_getDemangledTypeName(JSONResult) // check object name
                
                if JSONResult != nil {
                    if let result = JSONResult {
                        if result["objectId"] != nil {
                            completionHandler(result: true, error:nil)
                        }
                    } else {
                        completionHandler(result: nil, error: NSError(domain: "updateLocation parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse updateLocation"]))
                    }
                }else{
                    completionHandler(result: nil, error: NSError(domain: "updateLocation parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse updateLocation"]))
                }
            }
        }
    }
    
    func updateLocation(firstName: String?, lastName: String?, mapString: String?, mediaURL: String?, latitude: Double?, longitude: Double?, completionHandler: (result: Bool?, error: NSError?) -> Void) {
        
        let mutableMethod = ParseClient.Methods.StudentLocation
        let parameters = ["uniqueKey": UdacityClient.sharedInstance().uniqueKey!, "firstName": firstName!,
            "lastName": lastName!, "mapString": mapString!, "mediaURL": mediaURL!, "latitude": latitude!, "longitude": longitude!]
        
        /* 2. Make the request */
        taskForPUTMethod(mutableMethod, parameters: parameters as! [String : AnyObject]) { JSONResult, error in
            
            /* 3. Send the desired value(s) to completion handler */
            if let error = error {
                completionHandler(result: nil, error: error)
            } else {
                
                //let typeLongName = _stdlib_getDemangledTypeName(JSONResult) // check object name
                if JSONResult != nil {
                    if let result = JSONResult {
                        if result["updatedAt"] != nil {
                            completionHandler(result: true, error:nil)
                        }
                    } else {
                        completionHandler(result: nil, error: NSError(domain: "updateLocation parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse updateLocation"]))
                    }
                }else{
                    completionHandler(result: nil, error: NSError(domain: "updateLocation parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse updateLocation"]))
                }
            }
        }
    }
    
}