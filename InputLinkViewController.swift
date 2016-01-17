//
//  InputLinkViewController.swift
//  OnTheMap
//
//  Created by Lawrence Tan on 3/1/16.
//  Copyright © 2016 Lawrence Tan. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class InputLinkViewController: UIViewController, MKMapViewDelegate, UITextFieldDelegate {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var locationSearchString: String?
    var foundPlacemark : CLPlacemark?

    @IBOutlet weak var txtLink: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    
    var foundPlaceMark: CLPlacemark?
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.activityIndicator.hidden = true
        self.navigationItem.hidesBackButton = true
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonSystemItem.Cancel, target: self, action: Selector("cancel"))
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        getLocation()        
    }
    
    func cancel() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func getLocation() {
            
        if let placemark = self.foundPlacemark {
            self.foundPlaceMark = placemark
            let span = MKCoordinateSpan(latitudeDelta: 0.0001, longitudeDelta: 0.0001)
            let coordinate = placemark.location!.coordinate
            let region = MKCoordinateRegion(center: coordinate, span: span)
            
            // Here we create the annotation and set its coordiate, title, and subtitle properties
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            self.mapView.addAnnotation(annotation)
            
            self.mapView.setRegion(region, animated: true)                
        }
    }
    
    //MARK: TextField Delegate
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        textField.text = ""
        return true
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        textField.textAlignment = .Left
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        textField.textAlignment = .Center
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.textAlignment = .Center
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func onSubmit(sender: AnyObject) {
        
        if verifyUrl(self.txtLink.text) == true {
            doSubmit()
        }else{
            let message = "Please input an invalid link."
            let alert = UIAlertController(title: "", message: message, preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Cancel, handler: { (UIAlertAction) -> Void in
                
            }))
            self.presentViewController(alert, animated: true, completion: nil)
        }
        
    }
    
    func doSubmit() {
        let firstName = UdacityClient.sharedInstance().firstName!
        let lastName = UdacityClient.sharedInstance().lastName!
        let mapString = self.foundPlaceMark?.name
        let mediaURL = self.txtLink.text
        let latitude = self.foundPlaceMark?.location?.coordinate.latitude
        let longitude = self.foundPlaceMark?.location?.coordinate.longitude
        
        self.activityIndicator.hidden = false
        self.activityIndicator.startAnimating()
        
        ParseClient.sharedInstance().updatedLatitude = self.foundPlaceMark?.location?.coordinate.latitude
        ParseClient.sharedInstance().updatedLongitude = self.foundPlaceMark?.location?.coordinate.longitude
        
        if ParseClient.sharedInstance().isUpdate == true {
            
            ParseClient.sharedInstance().updateLocation(firstName, lastName: lastName, mapString: mapString, mediaURL: mediaURL, latitude: latitude, longitude: longitude, completionHandler: { (result, error) -> Void in
                
                self.activityIndicator.hidden = true
                self.activityIndicator.stopAnimating()
                
                if result == true {
                    NSNotificationCenter.defaultCenter().postNotificationName("SubmitLocationSuccessNotificaiton", object: nil)
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.dismissViewControllerAnimated(true, completion: nil)
                    })
                }else{
                    let message = error?.localizedDescription
                    let alert = UIAlertController(title: "", message: message, preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Cancel, handler: { (UIAlertAction) -> Void in
                        
                    }))
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.presentViewController(alert, animated: true, completion: nil)
                    })
                }
                
            })
            
        }else{
            
            ParseClient.sharedInstance().submitLocation(firstName, lastName: lastName, mapString: mapString, mediaURL: mediaURL, latitude: latitude, longitude: longitude) { (result, error) -> Void in
                
                self.activityIndicator.hidden = true
                self.activityIndicator.stopAnimating()
                
                if result == true {
                    NSNotificationCenter.defaultCenter().postNotificationName("SubmitLocationSuccessNotificaiton", object: nil)
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.dismissViewControllerAnimated(true, completion: nil)
                    })
                }else{
                    let message = error?.localizedDescription
                    let alert = UIAlertController(title: "", message: message, preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Cancel, handler: { (UIAlertAction) -> Void in
                        
                    }))
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.presentViewController(alert, animated: true, completion: nil)
                    })
                }
            }
        }
    }
    
    func verifyUrl (urlString: String?) -> Bool {
        //Check for nil
        if let urlString = urlString {
            // create NSURL instance
            if let url = NSURL(string: urlString) {
                // check if your application can open the NSURL instance
                return UIApplication.sharedApplication().canOpenURL(url)
            }
        }
        return false
    }
    
    
}
