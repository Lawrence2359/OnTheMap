//
//  StudentLocation.swift
//  OnTheMap
//
//  Created by Lawrence Tan on 3/1/16.
//  Copyright © 2016 Lawrence Tan. All rights reserved.
//

import UIKit

struct StudentLocation {
    
    var objectId: String? = nil
    var uniqueKey: String? = nil
    var firstName: String? = nil
    var lastName: String? = nil
    var mapString: String? = nil
    var mediaURL: String? = nil
    var latitude: NSNumber? = nil
    var longitude: NSNumber? = nil
    
    // MARK: Initializers
    
    /* Construct a StudentLocation from a dictionary */
    init(dictionary: [String : AnyObject]) {
        
        objectId = dictionary[ParseClient.JSONResponseKeys.ObjectId] as? String
        uniqueKey = dictionary[ParseClient.JSONResponseKeys.UniqueKey] as? String
        firstName = dictionary[ParseClient.JSONResponseKeys.FirstName] as? String
        lastName = dictionary[ParseClient.JSONResponseKeys.LastName] as? String
        mapString = dictionary[ParseClient.JSONResponseKeys.MapString] as? String
        mediaURL = dictionary[ParseClient.JSONResponseKeys.MediaURL] as? String
        latitude = dictionary[ParseClient.JSONResponseKeys.Latitude] as? NSNumber
        longitude = dictionary[ParseClient.JSONResponseKeys.Longitude] as? NSNumber
        
    }
    
    /* Helper: Given an array of dictionaries, convert them to an array of StudentLocation objects */
    static func locationsFromResults(results: [[String : AnyObject]]) -> [StudentLocation] {
        var studentLocations = [StudentLocation]()
        
        for result in results {
            studentLocations.append(StudentLocation(dictionary: result))
        }
        
        return studentLocations
    }
    
}
