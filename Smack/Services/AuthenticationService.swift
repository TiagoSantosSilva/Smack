//
//  AuthenticationService.swift
//  Smack
//
//  Created by Tiago Santos on 13/12/17.
//  Copyright © 2017 Tiago Santos. All rights reserved.
//

import Foundation
import Alamofire

class AuthenticationService {
    
    static let instance = AuthenticationService()
    
    let defaults = UserDefaults.standard
    
    var isLoggedIn : Bool {
        get {
            return defaults.bool(forKey: Logged_In_Key)
        }
        
        set {
            defaults.set(newValue, forKey: Logged_In_Key)
        }
    }
    
    var authenticationToken : String {
        get {
            return defaults.value(forKey: Token_Key) as! String
        }
        
        set {
            defaults.set(newValue, forKey: Token_Key)
        }
    }
    
    var userEmail : String {
        get {
            return defaults.value(forKey: User_Email) as! String
        }
        
        set {
            defaults.set(newValue, forKey: User_Email)
        }
    }
    
    func registerUser(email: String, password: String, completion: @escaping CompletionHandler) {
        
        let lowerCaseEmail = email.lowercased()
        
        let header = [
            "Content-Type": "application/json; charset=utf-8"
        ]
        
        let body: [String: Any] = [
            "email": lowerCaseEmail,
            "password": password
        ]
        
        Alamofire.request(Register_Url, method: .post, parameters: body, encoding: JSONEncoding.default, headers: header).responseString { (response) in
            
            if response.result == nil { // warning being shout here.. need to refractor it.
                completion(true)
            } else {
                completion(false)
                debugPrint(response.result.error as Any)
            }
        }
    }
}
