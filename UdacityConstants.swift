//
//  UdacityConstants.swift
//  OnTheMap
//
//  Created by Lawrence Tan on 1/1/16.
//  Copyright © 2016 Lawrence Tan. All rights reserved.
//

extension UdacityClient {
    
    // MARK: Constants
    struct Constants {
        
        // MARK: URLs
        static let BaseURLSecure : String = "https://www.udacity.com/api/"
        
    }
    
    // MARK: Methods
    struct Methods {
        
        // MARK: Account
        static let Session = "session"
        static let PublicUserData = "users/{id}"
    }
    
    // MARK: URL Keys
    struct URLKeys {
        
        static let UserID = "id"
        
    }
    
    // MARK: Parameter Keys
    struct ParameterKeys {
        
        static let SessionID = "session_id"
        static let Udacity = "udacity"
        static let Username = "username"
        static let Password = "password"
        static let FBMobile = "facebook_mobile"
        static let FBToken = "access_token"
    }
    
    // MARK: JSON Response Keys
    struct JSONResponseKeys {
        
        // MARK: General
        static let Account = "account"
        static let Session = "session"
        
        // MARK: Account
        static let Registered = "registered"
        static let Key = "key"
        
        // MARK: Session
        static let SessionID = "id"
        static let Expiration = "expiration"
        
    }
    
}
