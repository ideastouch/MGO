//
//  ViewController.swift
//  mgoclient
//
//  Created by Gustavo Halperin on 9/25/14.
//  Copyright (c) 2014 mgo. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {

    
    @IBOutlet private weak var _welcomeViewCenterYAlignment: NSLayoutConstraint!
    @IBOutlet private weak var _welcomeViewTopAlignment: NSLayoutConstraint!
    @IBOutlet private weak var _welcomeViewContainer: UIView!
    @IBOutlet private weak var _emailTextField: UITextField!
    @IBOutlet private weak var _passwordTextField: UITextField!
    private weak var _activeTextField: UITextField!
    private var _keyboardUserInfo: NSDictionary!
    private var _deviceIsRotating: Bool = false
    
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

    @IBAction func tapGestureRecognizerViewAction(sender: AnyObject) {
        _activeTextField?.resignFirstResponder()
    }
    
    func animateTextFieldUp(keyboardUserInfo userInfo:NSDictionary){
        let value:NSValue = _keyboardUserInfo[UIKeyboardFrameEndUserInfoKey] as NSValue
        var keyboardRect:CGRect = value.CGRectValue()
        
        var activeTextFieldRect:CGRect = _activeTextField.frame
        activeTextFieldRect = _welcomeViewContainer.convertRect(activeTextFieldRect, toView: self.view)
        let delta:CGFloat = activeTextFieldRect.origin.y + activeTextFieldRect.size.height - keyboardRect.origin.y
        if (delta > 0) {
            let animationCurve:NSNumber =  _keyboardUserInfo[UIKeyboardAnimationCurveUserInfoKey] as NSNumber
            let animationDuration:NSNumber =  _keyboardUserInfo[UIKeyboardAnimationDurationUserInfoKey] as NSNumber
            var welcomeViewTopAlignmentConstant:CGFloat = _welcomeViewContainer.frame.origin.y - delta
            
            
            UIView.animateWithDuration(
                animationDuration.doubleValue,
                delay: 0.0,
                options: UIViewAnimationOptions.fromRaw(UInt(animationCurve.unsignedIntValue))!,
                animations: {
                    self._welcomeViewTopAlignment.constant = welcomeViewTopAlignmentConstant
                    self._welcomeViewCenterYAlignment.priority = 250
                    self._welcomeViewTopAlignment.priority = 750
                    self.view.setNeedsLayout()
                },
                completion: nil
            )
        }
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if !_deviceIsRotating {
            self._keyboardUserInfo  = notification.userInfo!
            self.animateTextFieldUp(keyboardUserInfo: _keyboardUserInfo)
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if !_deviceIsRotating {
            self._keyboardUserInfo = notification.userInfo!
            let animationCurve:NSNumber =  _keyboardUserInfo[UIKeyboardAnimationCurveUserInfoKey] as NSNumber
            let animationDuration:NSNumber =  _keyboardUserInfo[UIKeyboardAnimationDurationUserInfoKey] as NSNumber
            
            UIView.animateWithDuration(
                animationDuration.doubleValue,
                delay: 0.0,
                options: UIViewAnimationOptions.fromRaw(UInt(animationCurve.unsignedIntValue))!,
                animations: {
                    self._welcomeViewCenterYAlignment.priority = 750
                    self._welcomeViewTopAlignment.priority = 250
                    self.view.setNeedsLayout()
                },
                completion:nil
            )
            self._keyboardUserInfo = nil
        }
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        _activeTextField = textField
        if (textField == _passwordTextField) {
            _passwordTextField.secureTextEntry = false
            if _keyboardUserInfo != nil {
                self.animateTextFieldUp(keyboardUserInfo: _keyboardUserInfo)
            }
        }
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
    
    override func willRotateToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation, duration: NSTimeInterval) {
        self._deviceIsRotating = true
    }
    
    override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation) {
        self._deviceIsRotating = false
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

