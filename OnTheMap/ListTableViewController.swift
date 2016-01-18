//
//  ListTableViewController.swift
//  OnTheMap
//
//  Created by Lawrence Tan on 3/1/16.
//  Copyright © 2016 Lawrence Tan. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class ListTableViewController: UIViewController, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
    }
    
    func loadData() {
        ParseClient.sharedInstance().getStudentLocations { (result, error) -> Void in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.hideLoadingView()
            })
            if result == true {
                let resultArray = StudentLocationsClient.sharedInstance.studentLocations
                if resultArray.count > 0 {
                    dispatch_async(dispatch_get_main_queue(),{
                        self.tableView.reloadData()
                    })
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
    
    // MARK: TableView Delegate
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return StudentLocationsClient.sharedInstance.studentLocations.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> ListItemCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("ListItemCell", forIndexPath: indexPath) as! ListItemCell
        
        let currStudentLocation: StudentLocation = StudentLocationsClient.sharedInstance.studentLocations[indexPath.row]
        cell.lblTitle.text = "\(currStudentLocation.firstName!) \(currStudentLocation.lastName!)"
        cell.lblLink.text = currStudentLocation.mediaURL
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let currStudentLocation: StudentLocation = StudentLocationsClient.sharedInstance.studentLocations[indexPath.row]
        let app = UIApplication.sharedApplication()
        app.openURL(NSURL(string:currStudentLocation.mediaURL!)!)
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
        self.presentViewController(UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("PopNav"), animated: true, completion: nil)        
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
