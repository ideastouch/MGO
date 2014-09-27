//
//  ViewController.swift
//  mgoclient
//
//  Created by Gustavo Halperin on 9/25/14.
//  Copyright (c) 2014 mgo. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {

    
    @IBOutlet weak var _welcomeViewCenterYAlignment: NSLayoutConstraint!
    @IBOutlet weak var _welcomeViewTopAlignment: NSLayoutConstraint!
    @IBOutlet weak var _welcomeViewContainer: UIView!
    @IBOutlet weak var _emailTextField: UITextField!
    @IBOutlet weak var _passwordTextField: UITextField!
    weak var _activeTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func tapGestureRecognizerViewAction(sender: AnyObject) {
        _activeTextField?.resignFirstResponder()
    }
    
    func keyboardWillShow(notification: NSNotification) {
        let userInfo: Dictionary = notification.userInfo!
        let value:NSValue = userInfo[UIKeyboardFrameEndUserInfoKey] as NSValue
        var keyboardRect:CGRect = value.CGRectValue()
        
        var activeTextFieldRect:CGRect = _activeTextField.frame
        activeTextFieldRect = _welcomeViewContainer.convertRect(activeTextFieldRect, toView: self.view)
        let delta:CGFloat = activeTextFieldRect.origin.y + activeTextFieldRect.size.height - keyboardRect.origin.y
        if (delta > 0) {
            let animationCurve:NSNumber =  userInfo[UIKeyboardAnimationCurveUserInfoKey] as NSNumber
            let animationDuration:NSNumber =  userInfo[UIKeyboardAnimationDurationUserInfoKey] as NSNumber
            var welcomeViewTopAlignmentConstant:CGFloat = _welcomeViewContainer.frame.origin.y - delta
            
            
            UIView.animateWithDuration(
                animationDuration.doubleValue,
                delay: 0.0,
                options: UIViewAnimationOptions.fromRaw(UInt(animationCurve.unsignedIntValue))!,  //.CurveEaseInOut,
                animations: {
                    self._welcomeViewTopAlignment.constant = welcomeViewTopAlignmentConstant
                    self._welcomeViewCenterYAlignment.priority = 250
                    self._welcomeViewTopAlignment.priority = 750
                    self.view.setNeedsLayout()
            },
                completion: {
                    (value: Bool) in
                    
                }
            )
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        UIView.animateWithDuration(
            1.0,//animationDuration.doubleValue,
            delay: 0.0,
            options: .CurveEaseInOut,//animationCurve.unsignedIntValue,
            animations: {
                self._welcomeViewCenterYAlignment.priority = 750
                self._welcomeViewTopAlignment.priority = 250
                self.view.setNeedsLayout()
            },
            completion: {
                (value: Bool) in
                
            }
        )
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        _activeTextField = textField
        if (textField == _passwordTextField) {
            _passwordTextField.secureTextEntry = false
        }
        return true
    }
    
    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        _activeTextField = nil
        if (textField == _passwordTextField) {
            _passwordTextField.secureTextEntry = true
        }
        
        return true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if (textField == _emailTextField) {
            textField.resignFirstResponder()
            _passwordTextField.becomeFirstResponder()
        }
        else {
            _passwordTextField.resignFirstResponder()
        }
        return true
    }

    func loginCommunAction(valuesMatchFunc:((Void)->Void)) {
        var loginModel: LoginModel = LoginModel.sharedInstance
        loginModel._userName = _emailTextField.text
        loginModel._password = _passwordTextField.text
        if loginModel.usernameIsLegal() {
            if loginModel.passwordIsLegal() {
                valuesMatchFunc()
            }
            else { // Bad Password
                var alert:UIAlertController = UIAlertController(
                    title: "Bad Password",
                    message: "The password must contain at least one capital letter, on lower letter, one number and a minumun of 8 letters",
                    preferredStyle: UIAlertControllerStyle.Alert)
                var okAction:UIAlertAction = UIAlertAction(title: "OK",
                    style: UIAlertActionStyle.Cancel,
                    handler: nil)
                alert.addAction(okAction)
                self.presentViewController(alert, animated: true, completion: nil)
            }
        }
        else { // Bad Email Address
            var alert:UIAlertController = UIAlertController(
                title: "Bad Email Address",
                message: "Please check your email addres.",
                preferredStyle: UIAlertControllerStyle.Alert)
            var okAction:UIAlertAction = UIAlertAction(title: "OK",
                style: UIAlertActionStyle.Cancel,
                handler: nil)
            alert.addAction(okAction)
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func loginAction(sender: AnyObject) {
        self.loginCommunAction( { () -> Void in
            var loginModel: LoginModel = LoginModel.sharedInstance
            loginModel.login({ (success: Bool) -> Void in
                if success {
                    self.performSegueWithIdentifier("LoginSegue", sender: self)
                    self._passwordTextField.text = ""
                }
                else {
                    var alert:UIAlertController = UIAlertController(
                        title: "Bad Password",
                        message: "The password used not mach with the registered one.\n Please try agaim or sign up with a diferent email",
                        preferredStyle: UIAlertControllerStyle.Alert)
                    var okAction:UIAlertAction = UIAlertAction(title: "OK",
                        style: UIAlertActionStyle.Cancel,
                        handler: nil)
                    alert.addAction(okAction)
                    self.presentViewController(alert, animated: true, completion: nil)
                }
            })
        })
    }
    
    
    @IBAction func signUpAction(sender: AnyObject) {
        self.loginCommunAction ( { () -> Void in
            var loginModel: LoginModel = LoginModel.sharedInstance
            loginModel.signUp({ (success: Bool) -> Void in
                if success {
                    self.performSegueWithIdentifier("LoginSegue", sender: self)
                    self._passwordTextField.text = ""
                }
                else {
                    var alert:UIAlertController = UIAlertController(
                        title: "User Exist",
                        message: "The email used was registered already. Please try a diferent email",
                        preferredStyle: UIAlertControllerStyle.Alert)
                    var okAction:UIAlertAction = UIAlertAction(title: "OK",
                        style: UIAlertActionStyle.Cancel,
                        handler: nil)
                    alert.addAction(okAction)
                    self.presentViewController(alert, animated: true, completion: nil)
                }
            })
        })
    }
}

