//
//  UdacityConvenience.swift
//  OnTheMap
//
//  Created by Lawrence Tan on 1/1/16.
//  Copyright © 2016 Lawrence Tan. All rights reserved.
//

import UIKit
import Foundation

// MARK: - UdacityClient (Convenient Resource Methods)

extension UdacityClient {
    
    
    func loginWithUsernameAndPassword(username: String?, password: String?, completionHandler: (result: Bool?, error: NSError?) -> Void) {
        
        let mutableMethod = UdacityClient.Methods.Session
        let parameters = ["udacity":["username": username!, "password": password!]]
        
        /* 2. Make the request */
        taskForPOSTMethod(mutableMethod, parameters: parameters) { JSONResult, error in
            
            /* 3. Send the desired value(s) to completion handler */
            if let error = error {
                completionHandler(result: nil, error: error)
            } else {
                
                //let typeLongName = _stdlib_getDemangledTypeName(JSONResult) // check object name
                
                if JSONResult != nil {
                
                    if let results = JSONResult[UdacityClient.JSONResponseKeys.Account]!![UdacityClient.JSONResponseKeys.Registered]! as? Bool {
                        
                        UdacityClient.sharedInstance().uniqueKey = JSONResult[UdacityClient.JSONResponseKeys.Account]!![UdacityClient.JSONResponseKeys.Key]! as? String
                        completionHandler(result: results, error: nil)
                    } else {
                        completionHandler(result: nil, error: NSError(domain: "loginWithUsernameAndPassword parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse loginWithUsernameAndPassword"]))
                    }
                }else{
                    
                    completionHandler(result: nil, error: error)
                }
            }
        }
    }
    
    func loginWithFacebook(access_token: String?, completionHandler: (result: Bool?, error: NSError?) -> Void) {
        
        let mutableMethod = UdacityClient.Methods.Session
        let parameters = ["facebook_mobile":["access_token": access_token!]]
        
        /* 2. Make the request */
        taskForFBPOSTMethod(mutableMethod, parameters: parameters) { JSONResult, error in
            
            /* 3. Send the desired value(s) to completion handler */
            if let error = error {
                completionHandler(result: nil, error: error)
            } else {
                
                //let typeLongName = _stdlib_getDemangledTypeName(JSONResult) // check object name
                
                if JSONResult != nil {
                    
                    if let results = JSONResult[UdacityClient.JSONResponseKeys.Account]!![UdacityClient.JSONResponseKeys.Registered]! as? Bool {
                        
                        UdacityClient.sharedInstance().uniqueKey = JSONResult[UdacityClient.JSONResponseKeys.Account]!![UdacityClient.JSONResponseKeys.Key]! as? String
                        completionHandler(result: results, error: nil)
                    } else {
                        completionHandler(result: nil, error: NSError(domain: "loginWithFacebook parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse loginWithFacebook"]))
                    }
                }else{
                    
                    completionHandler(result: nil, error: error)
                }
            }
        }
    }
    
    func getPublicUserData(completionHandler: (result: AnyObject?, error: NSError?) -> Void) {
        
        /* 1. Specify parameters, method (if has {key}), and HTTP body (if POST) */
        var mutableMethod : String = Methods.PublicUserData
        mutableMethod = UdacityClient.subtituteKeyInMethod(mutableMethod, key: UdacityClient.URLKeys.UserID, value: String(UdacityClient.sharedInstance().uniqueKey!))!
        
        /* 2. Make the request */
        taskForGETMethod(mutableMethod, parameters: ["":""]) { JSONResult, error in
            
            /* 3. Send the desired value(s) to completion handler */
            if let error = error {
                completionHandler(result: nil, error: error)
            } else {
                completionHandler(result: JSONResult, error: error)
            }
        }
    }
    
    func logout(completionHandler: (result: AnyObject?, error: NSError?) -> Void) {
        
        let mutableMethod : String = Methods.Session
        
        /* 2. Make the request */
        taskForDELETEMethod(mutableMethod, parameters: ["":""]) { JSONResult, error in
            
            /* 3. Send the desired value(s) to completion handler */
            if let error = error {
                completionHandler(result: nil, error: error)
            } else {
                completionHandler(result: JSONResult, error: error)
            }
        }
    }
    
}
