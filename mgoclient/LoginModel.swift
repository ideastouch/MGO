//
//  LoginModel.swift
//  mgoclient
//
//  Created by Gustavo Halperin on 9/26/14.
//  Copyright (c) 2014 mgo. All rights reserved.
//

import Foundation

class LoginModel {
    var _userName:String! = nil
    var _password:String! = nil
    private var _userDefults:NSMutableDictionary! = nil
    
    class var sharedInstance: LoginModel {
    struct Static {
        static let instance: LoginModel = LoginModel()
        }
        return Static.instance
    }
    
    func userDefults(Void) -> NSDictionary {
        if _userDefults == nil {
            if let dictionary:NSDictionary = NSUserDefaults().dictionaryForKey("Credentials") {
                _userDefults = NSMutableDictionary(dictionary: dictionary)
            }
            else {
                _userDefults = NSMutableDictionary(object: NSMutableDictionary(), forKey: "Credentials")
            }
        }
        return _userDefults
    }
    
    func usernameIsLegal(Void) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let range = _userName.rangeOfString(emailRegEx, options:.RegularExpressionSearch)
        let result = range != nil ? true : false
        return result
    }
    
    func passwordIsLegal(Void) -> Bool {
        var result = true
        let capitalRegEx = "[A-Z]"
        let lowerRegEx = "[a-z]"
        let numberRegEx = "[0-9]"
        
        for regex in [capitalRegEx, lowerRegEx, numberRegEx] {
            var range = _password.rangeOfString(regex, options: .RegularExpressionSearch)
            result = range != nil ? true : false
            if result == false {
                break
            }
        }
        if result {
            result = _password.lengthOfBytesUsingEncoding(NSASCIIStringEncoding) >= 8
        }
        
        return result
    }
    
    func login(completion:((success:Bool)->Void)) -> Void {
        var succeded = false
        if(   self.usernameIsLegal()
            && self.passwordIsLegal() ) {
                var password:String? = self.userDefults().valueForKey(_userName) as String?
                 succeded = password == _password
        }
        completion(success: succeded)
    }
    
    func signUp(completion:((success:Bool)->Void)) -> Void {
        var succeded = false
        if(   self.usernameIsLegal()
            && self.passwordIsLegal() ) {
                if var password: AnyObject = self.userDefults().objectForKey(_userName) {
                    succeded = false
                }
                else {
                    succeded = true
                }
        }
        completion(success: succeded)
        if succeded {
            self.userDefults().setValue(_password, forKey: _userName)
            NSUserDefaults().setObject(self.userDefults(), forKey: "Credentials")
            NSUserDefaults().synchronize()
        }
    }
    
}