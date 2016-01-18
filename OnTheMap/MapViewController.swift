//
//  MapViewController.swift
//  OnTheMap
//
//  Created by Lawrence Tan on 3/1/16.
//  Copyright © 2016 Lawrence Tan. All rights reserved.
//

import UIKit
import MapKit
import FBSDKLoginKit

class MapViewController: UIViewController, MKMapViewDelegate, UIAlertViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!    
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var zoomRect: MKMapRect = MKMapRectNull;
    
    override func viewDidLoad() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "didSubmitMapCompletedSuccess:", name:"SubmitLocationSuccessNotificaiton", object: nil)
    }
    
    @objc private func didSubmitMapCompletedSuccess(notification: NSNotification){
        loadData()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.zoomMapToFitAnnotations()
    }
    
    func loadData() {
        showLoadingView()
        ParseClient.sharedInstance().getStudentLocations { (result, error) -> Void in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.hideLoadingView()
            })
            if result == true {
                let resultArray = StudentLocationsClient.sharedInstance.studentLocations
                if resultArray.count > 0 {
                    self.reloadMap(resultArray)
                }
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
    
    func showLoadingView() {
        loadingView.hidden = false
        activityIndicator.startAnimating()
    }
    
    func hideLoadingView() {
        loadingView.hidden = true
        activityIndicator.stopAnimating()
    }
    
    func reloadMap(locations: [StudentLocation]) {
        
        // We will create an MKPointAnnotation for each dictionary in "locations". The
        // point annotations will be stored in this array, and then provided to the map view.
        var annotations = [MKPointAnnotation]()
        
        // The "locations" array is loaded with the sample data below. We are using the dictionaries
        // to create map annotations. This would be more stylish if the dictionaries were being
        // used to create custom structs. Perhaps StudentLocation structs.
        
        for studentLocation in locations {
            
            // Notice that the float values are being used to create CLLocationDegree values.
            // This is a version of the Double type.
            let lat = CLLocationDegrees(studentLocation.latitude as! Double)
            let long = CLLocationDegrees(studentLocation.longitude as! Double)
            
            // The lat and long are used to create a CLLocationCoordinates2D instance.
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            
            let first = studentLocation.firstName as String?
            let last = studentLocation.lastName as String?
            let mediaURL = studentLocation.mediaURL as String?
            
            // Here we create the annotation and set its coordiate, title, and subtitle properties
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "\(first!) \(last!)"
            annotation.subtitle = mediaURL
            
            // Finally we place the annotation in an array of annotations.
            annotations.append(annotation)
        }
        
        // When the array is complete, we add the annotations to the map.
        self.mapView.addAnnotations(annotations)
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            self.hideLoadingView()            
        }
    }
    
    func zoomMapToFitAnnotations() {
        for annotation in self.mapView.annotations {
            let annotationPoint: MKMapPoint = MKMapPointForCoordinate(annotation.coordinate);
            let pointRect: MKMapRect = MKMapRectMake(annotationPoint.x, annotationPoint.y, 0, 0);
            if (MKMapRectIsNull(zoomRect)) {
                zoomRect = pointRect;
            } else {
                zoomRect = MKMapRectUnion(zoomRect, pointRect);
            }
        }
        self.mapView.setVisibleMapRect(zoomRect, animated: true)
    }
    
    func zoomMapToFitNewLocation() {
        self.mapView.setVisibleMapRect(zoomRect, animated: true)
    }
    
    // MARK: - MKMapViewDelegate
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = UIColor.redColor()
            pinView!.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    func mapView(mapView: MKMapView, annotationView: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        if control == annotationView.rightCalloutAccessoryView {
            let app = UIApplication.sharedApplication()
            app.openURL(NSURL(string: annotationView.annotation!.subtitle!!)!)
        }
    }
    
    @IBAction func onLogout(sender: AnyObject) {
        showLoadingView()
        UdacityClient.sharedInstance().logout { (result, error) -> Void in
            self.hideLoadingView()
            if result!["id"] != nil {
                if UdacityClient.sharedInstance().loginType == UdacityLoginType.Facebook {
                    let fbLoginManager = FBSDKLoginManager()
                    fbLoginManager.logOut()
                }
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
    
    @IBAction func onRefresh(sender: AnyObject) {
        loadData()
    }
    
    @IBAction func onSubmitLocation(sender: AnyObject) {
        if checkIfUserHasAddedBefore() == true {
            let message = "User \"\(UdacityClient.sharedInstance().firstName!) \(UdacityClient.sharedInstance().lastName!)\" Has Already Posted a Student Location. Would You Like to Overwrite Their Location?"
            let alert = UIAlertController(title: "", message: message, preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: { (UIAlertAction) -> Void in
                
            }))
            alert.addAction(UIAlertAction(title: "Overwrite", style: UIAlertActionStyle.Default, handler: { (UIAlertAction) -> Void in
                ParseClient.sharedInstance().isUpdate = true
                self.goToSubmitLocation()
            }))
            presentViewController(alert, animated: true, completion: nil)
        }else{
            ParseClient.sharedInstance().isUpdate = false
            goToSubmitLocation()
        }
    }
    
    func goToSubmitLocation() {
        self.presentViewController(UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("PopNav"), animated: true, completion: nil)
    }

    func checkIfUserHasAddedBefore() -> Bool {
        for studentLocation in StudentLocationsClient.sharedInstance.studentLocations {
            if studentLocation.uniqueKey! == UdacityClient.sharedInstance().uniqueKey! {
                ParseClient.sharedInstance().objectId = studentLocation.objectId!
                return true
            }
        }
        return false
    }
    
}
