//
//  ParseConstants.swift
//  OnTheMap
//
//  Created by Lawrence Tan on 3/1/16.
//  Copyright © 2016 Lawrence Tan. All rights reserved.
//

import Foundation

extension ParseClient {
    
    // MARK: Constants
    struct Constants {
        
        // MARK: URLs
        static let BaseURLSecure : String = "https://api.parse.com/1/classes/"
        
        // MARK: Keys
        static let ApplicationKey : String = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        static let RESTKey : String = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
        
    }
    
    // MARK: Methods
    struct Methods {
        
        // MARK: Account
        static let StudentLocation = "StudentLocation"
        
    }
    
    // MARK: JSON Response Keys
    struct JSONResponseKeys {
        
        // MARK: StudentLocation
        static let StudentLocationsResults = "results"
        static let ObjectId = "objectId"
        static let UniqueKey = "uniqueKey"
        static let FirstName = "firstName"
        static let LastName = "lastName"
        static let MapString = "mapString"
        static let MediaURL = "mediaURL"
        static let Latitude = "latitude"
        static let Longitude = "longitude"
        
    }

}