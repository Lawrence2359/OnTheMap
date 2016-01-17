//
//  LoginWebViewController.swift
//  OnTheMap
//
//  Created by Lawrence Tan on 1/1/16.
//  Copyright © 2016 Lawrence Tan. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.hidden = true
    }
    
    @IBAction func onLogin(sender: AnyObject) {
        activityIndicator.hidden = false
        activityIndicator.startAnimating()
        UdacityClient.sharedInstance().loginWithUsernameAndPassword(self.txtUsername.text, password: self.txtPassword.text) { (result, error) -> Void in
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.activityIndicator.stopAnimating()
                self.activityIndicator.hidden = true
            })
            
            if error != nil {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    let alert = UIAlertController.init(title: nil, message: error?.localizedDescription, preferredStyle: UIAlertControllerStyle.Alert)
                    let cancelAction: UIAlertAction = UIAlertAction(title: "Ok", style: .Cancel) { action -> Void in
                    }
                    alert.addAction(cancelAction)
                    self.presentViewController(alert, animated: true, completion:nil)
                })
            } else {
                UdacityClient.sharedInstance().getPublicUserData({ (result, error) -> Void in
                    
                    if error != nil {
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            let alert = UIAlertController.init(title: nil, message: error?.localizedDescription, preferredStyle: UIAlertControllerStyle.Alert)
                            let cancelAction: UIAlertAction = UIAlertAction(title: "Ok", style: .Cancel) { action -> Void in
                            }
                            alert.addAction(cancelAction)
                            self.presentViewController(alert, animated: true, completion:nil)
                        })
                    } else {
                        let first_name = result!["user"]!!["first_name"]! as! String?
                        let last_name = result!["user"]!!["last_name"]! as! String?
                        
                        UdacityClient.sharedInstance().firstName = first_name
                        UdacityClient.sharedInstance().lastName = last_name
                        
                        UdacityClient.sharedInstance().loginType = UdacityLoginType.Normal
                        
                        if first_name != nil {
                            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                self.presentViewController(UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("MainTabController"), animated: true, completion: nil)
                            })
                        }
                    }
                    
                })
            }
        }
    }
    
    @IBAction func onSignUp(sender: AnyObject) {
        UIApplication.sharedApplication().openURL(NSURL(string: "https://www.udacity.com/account/auth#!/signin")!)
    }
    
    @IBAction func onFacebook(sender: AnyObject) {
        activityIndicator.hidden = false
        activityIndicator.startAnimating()
        let login = FBSDKLoginManager()
        login.logInWithReadPermissions(["public_profile"], fromViewController: self) { (FBSDKLoginManagerLoginResult result, NSError error) -> Void in
            if error != nil {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    let alert = UIAlertController.init(title: nil, message: error?.localizedDescription, preferredStyle: UIAlertControllerStyle.Alert)
                    let cancelAction: UIAlertAction = UIAlertAction(title: "Ok", style: .Cancel) { action -> Void in
                    }
                    alert.addAction(cancelAction)
                    self.presentViewController(alert, animated: true, completion:nil)
                })
            }else if result.isCancelled {
                let alert = UIAlertController.init(title: nil, message: "Facebook Login cancelled", preferredStyle: UIAlertControllerStyle.Alert)
                let cancelAction: UIAlertAction = UIAlertAction(title: "Ok", style: .Cancel) { action -> Void in
                }
                alert.addAction(cancelAction)
                self.presentViewController(alert, animated: true, completion:nil)
            }else{
                UdacityClient.sharedInstance().loginWithFacebook(FBSDKAccessToken.currentAccessToken().tokenString, completionHandler: { (result, error) -> Void in
                    
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.activityIndicator.stopAnimating()
                        self.activityIndicator.hidden = true
                    })
                    
                    if error != nil {
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            let alert = UIAlertController.init(title: nil, message: error?.localizedDescription, preferredStyle: UIAlertControllerStyle.Alert)
                            let cancelAction: UIAlertAction = UIAlertAction(title: "Ok", style: .Cancel) { action -> Void in
                            }
                            alert.addAction(cancelAction)
                            self.presentViewController(alert, animated: true, completion:nil)
                        })
                    } else {
                        UdacityClient.sharedInstance().getPublicUserData({ (result, error) -> Void in
                            
                            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                self.activityIndicator.stopAnimating()
                                self.activityIndicator.hidden = true
                            })
                            
                            if error != nil {
                                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                    let alert = UIAlertController.init(title: nil, message: error?.localizedDescription, preferredStyle: UIAlertControllerStyle.Alert)
                                    let cancelAction: UIAlertAction = UIAlertAction(title: "Ok", style: .Cancel) { action -> Void in
                                    }
                                    alert.addAction(cancelAction)
                                    self.presentViewController(alert, animated: true, completion:nil)
                                })
                            } else {
                                let first_name = result!["user"]!!["first_name"]! as! String?
                                let last_name = result!["user"]!!["last_name"]! as! String?
                                
                                UdacityClient.sharedInstance().firstName = first_name
                                UdacityClient.sharedInstance().lastName = last_name
                                
                                UdacityClient.sharedInstance().loginType = UdacityLoginType.Facebook
                                
                                if first_name != nil {
                                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                        self.presentViewController(UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("MainTabController"), animated: true, completion: nil)
                                    })
                                }
                            }
                        })
                    }
                })
            }
        }
    }
}
