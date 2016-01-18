//
//  InputLocationViewController.swift
//  OnTheMap
//
//  Created by Lawrence Tan on 3/1/16.
//  Copyright © 2016 Lawrence Tan. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class InputLocationViewController: UIViewController, UITextFieldDelegate, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var lblQuestion: UILabel!
    @IBOutlet weak var txtLocation: UITextField!
    @IBOutlet weak var txtFieldView: UIView!
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: self, action: Selector("tapOnView"))
        tap.delegate = self
        txtFieldView.addGestureRecognizer(tap)
    }
    
    func tapOnView() {
        txtLocation.becomeFirstResponder()
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
    
    @IBAction func onFindOnTheMap(sender: AnyObject) {
        
        if txtLocation.text != "Enter Your Location Here" && txtLocation.text?.characters.count > 1 {
            
            let geoCoder = CLGeocoder()
            let addressString = txtLocation.text!
            
            showLoadingView()
            
            geoCoder.geocodeAddressString(addressString) { (placemarks: [CLPlacemark]?, error: NSError?) -> Void in
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.hideLoadingView()  
                })
                if (error != nil) {
                    let alert = UIAlertController.init(title: nil, message: "Could not geocode location", preferredStyle: UIAlertControllerStyle.Alert)
                    let cancelAction: UIAlertAction = UIAlertAction(title: "Ok", style: .Cancel) { action -> Void in
                        //Just dismiss the action sheet
                        self.navigationController?.popViewControllerAnimated(true)
                    }
                    alert.addAction(cancelAction)
                    self.presentViewController(alert, animated: true, completion:nil)
                }else{
                    let dst: InputLinkViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("InputLinkViewController") as! InputLinkViewController
                    dst.locationSearchString = self.txtLocation.text
                    dst.foundPlacemark = placemarks?.first
                    self.navigationController?.pushViewController(dst, animated: true)
                }
            }
            
        }else{
            let alert = UIAlertController.init(title: nil, message: "Please input a location", preferredStyle: UIAlertControllerStyle.Alert)
            let cancelAction: UIAlertAction = UIAlertAction(title: "Ok", style: .Cancel) { action -> Void in
                //Just dismiss the action sheet
                self.navigationController?.popViewControllerAnimated(true)
            }
            alert.addAction(cancelAction)
            self.presentViewController(alert, animated: true, completion:nil)
        }
    }
    
    @IBAction func onCancel(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func showLoadingView() {
        loadingView.hidden = false
        activityIndicator.startAnimating()
    }
    
    func hideLoadingView() {
        loadingView.hidden = true
        activityIndicator.stopAnimating()
    }
    
}
