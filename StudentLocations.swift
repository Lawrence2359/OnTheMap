//
//  StudentLocations.swift
//  OnTheMap
//
//  Created by Lawrence Tan on 17/1/16.
//  Copyright © 2016 Lawrence Tan. All rights reserved.
//

import UIKit

class StudentLocationsClient {
    
    var studentLocations = [StudentLocation]()
    
    class var sharedInstance: StudentLocationsClient {
        struct Static {
            static var onceToken: dispatch_once_t = 0
            static var instance: StudentLocationsClient? = nil
        }
        dispatch_once(&Static.onceToken) {
            Static.instance = StudentLocationsClient()
        }
        return Static.instance!
    }
}
