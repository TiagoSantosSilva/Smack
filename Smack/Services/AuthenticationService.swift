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
        
        let body: [String: Any] = [
            "email": lowerCaseEmail,
            "password": password
        ]
        
        Alamofire.request(Register_Url, method: .post, parameters: body, encoding: JSONEncoding.default, headers: Request_Header).responseString { (response) in
            
            if response.result.error == nil {
                completion(true)
            }
            else {
                completion(false)
                debugPrint(response.result.error as Any)
            }
        }
    }
    
    func loginUser(email: String, password: String, completion: @escaping CompletionHandler) {
        
        let lowerCaseEmail = email.lowercased()
        
        let body: [String: Any] = [
            "email": lowerCaseEmail,
            "password": password
        ]
        
        Alamofire.request(Login_Url, method: .post, parameters: body, encoding: JSONEncoding.default, headers: Request_Header).responseJSON(completionHandler: { (response) in
            
            if response.result.error == nil {
                guard let json = response.result.value as? Dictionary<String, Any> else {
                    debugPrint("Json dictionary let failed.")
                    return
                }
                
                guard let email = json["user"] as? String else { return }
                guard let token = json["token"] as? String else { return }
                
                self.userEmail = email
                self.authenticationToken = token
                
                completion(true)
            } else {
                completion(false)
                debugPrint(response.result.error as Any)
            }
        })
    }
}
