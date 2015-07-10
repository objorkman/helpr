
//
//  RequestViewController.swift
//  SimpleApp
//
//  Created by Oscar Bjorkman on 7/8/15.
//  Copyright (c) 2015 Oscar Bjorkman. All rights reserved.
//

import UIKit
import Parse
import Bolts
import SwiftSpinner

class RequestViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: - Variables
    
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    // MARK: - Outlets

    @IBOutlet weak var requestTextField: UITextField!
    
    @IBOutlet weak var requestLabel: UILabel!
    
    // MARK: - Actions
    
    @IBAction func requestButton(sender: AnyObject) {
        println("Pressed request button")
        addSpinner("Requesting task", Animated: true)
        
        if requestTextField.text == "" {
            delay(seconds: 1.0, completion: { () -> () in
                self.addSpinner("Enter a task", Animated: false)
                self.delay(seconds: 1.0, completion: { () -> () in
                    self.hideSpinner()
                })
            })
            // TODO: - Have to press button twice
        }
        else {
            
            var request = PFObject(className: "request")
            request["requester"] = PFUser.currentUser()?.username
            request["task"] = requestTextField.text
            
            var query = PFQuery(className: "request")
            query.whereKey("task", equalTo: requestTextField.text)
            query.whereKey("requester", equalTo: PFUser.currentUser()!.username!)
            
            query.findObjectsInBackgroundWithBlock {
                (objects: [AnyObject]?, error: NSError?) -> Void in
                
                if error == nil {
                    // The find succeeded.
                    println("Successfully retrieved \(objects!.count) tasks.")
                    // Do something with the found objects
                    if objects!.count == 0 {
                        request.saveInBackgroundWithBlock({ (didWork, error) -> Void in
                            self.delay(seconds: 1.0, completion: { () -> () in
                                println(request)
                                if error != nil {
                                    // handle error
                                    println("Error")
                                    self.addSpinner("Please try again later", Animated: false)
                                    self.delay(seconds: 1.0, completion: { () -> () in
                                        self.hideSpinner()
                                    })
                                } else {
                                    println("Success")
                                    self.addSpinner("Success", Animated: false)
                                    self.delay(seconds: 1.0, completion: { () -> () in
                                        self.hideSpinner()
                                    })
                                }
                            })
                            
                        })
                    } else {
                        self.delay(seconds: 1.0, completion: { () -> () in
                            self.addSpinner("Already requested task", Animated: false)
                            self.delay(seconds: 1.0, completion: { () -> () in
                                self.hideSpinner()
                            })
                        })
                        
                    }
                } else {
                    // Log details of the failure
                    println("Error: \(error!) \(error!.userInfo!)")
                }
            }

            
//            request.saveInBackgroundWithBlock({ (didWork, error) -> Void in
//                self.delay(seconds: 1.0, completion: { () -> () in
//                    println(request)
//                    if error != nil {
//                        // handle error
//                        println("Error")
//                        self.addSpinner("Please try again later", Animated: false)
//                        self.delay(seconds: 1.0, completion: { () -> () in
//                            self.hideSpinner()
//                        })
//                    } else {
//                        println("Success")
//                        self.addSpinner("Success", Animated: false)
//                        self.delay(seconds: 1.0, completion: { () -> () in
//                            self.hideSpinner()
//                        })
//                    }
//                })
//                
//            })
            
        }
    }
    
    // MARK: - View
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        requestTextField.delegate = self
        requestTextField.tintColor = UIColor.whiteColor()
        
        requestTextField.attributedPlaceholder = NSAttributedString(string: "Request", attributes: [NSForegroundColorAttributeName: UIColor.whiteColor()])
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        self.view.endEditing(true)
    }
    
    // MARK: - Activity Indicator
    
    func showActivity() {
        
        activityIndicator = UIActivityIndicatorView(frame: CGRectMake(0, 0, 50, 50))
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
        
    }
    
    func endActivity() {
        
        self.activityIndicator.stopAnimating()
        UIApplication.sharedApplication().endIgnoringInteractionEvents()
    }
    
    func addSpinner(Error: String, Animated: Bool) {
        SwiftSpinner.show(Error, animated: Animated)
    }
    
    func hideSpinner() {
        SwiftSpinner.hide()
    }
    
    func delay(#seconds: Double, completion:()->()) {
        let popTime = dispatch_time(DISPATCH_TIME_NOW, Int64( Double(NSEC_PER_SEC) * seconds ))
        
        dispatch_after(popTime, dispatch_get_main_queue()) {
            completion()
        }
    }

    
    // MARK: - Alert
    
    func displayAlertNoSegue(title: String, error: String) {
        
        var alert = UIAlertController(title: title, message: error, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { action in
            
            
        }))
        
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}