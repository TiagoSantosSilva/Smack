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
    let jsonDecoder : JSONDecoder
    let jsonEncoder : JSONEncoder
    
    init() {
        jsonDecoder = JSONDecoder()
        jsonEncoder = JSONEncoder()
        jsonEncoder.outputFormatting = .prettyPrinted
    }
    
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
    
    func registerUser(user: User, completion: @escaping CompletionHandler) {
        
        let userContent = user.convertUserToStringDictionary(jsonEncoder: jsonEncoder)
        
        Alamofire.request(Register_Url, method: .post, parameters: userContent, encoding: JSONEncoding.default, headers: Request_Header).responseString { (response) in
            
            if response.result.error == nil {
                completion(true)
            }
            else {
                completion(false)
                debugPrint(response.result.error as Any)
            }
        }
    }
    
    func loginUser(user: User, completion: @escaping CompletionHandler) {
        
        let userContent = user.convertUserToStringDictionary(jsonEncoder: jsonEncoder)
        
        Alamofire.request(Login_Url, method: .post, parameters: userContent, encoding: JSONEncoding.default, headers: Request_Header).responseJSON(completionHandler: { (response) in
            
            if response.result.error == nil {
                
                let userFromResponse = convertStringDictionaryToUser(content: response.result.value, jsonDecoder: self.jsonDecoder)
                
                guard let userEmail = userFromResponse.user else { return }
                guard let authenticationToken = userFromResponse.token else { return }
                
                self.userEmail = userEmail
                self.authenticationToken = authenticationToken
                
                print("Created user 🌞: \n \(user)")
                self.isLoggedIn = true
                completion(true)
            } else {
                completion(false)
                debugPrint(response.result.error as Any)
            }
        })
    }
    
    fileprivate func setUserInfo(_ response: (DataResponse<Any>)) {
        let userFromResponse = convertStringDictionaryToUser(content: response.result.value, jsonDecoder: self.jsonDecoder)
        
        UserDataService.instance.setUserData(id: userFromResponse._id!, color: userFromResponse.avatarColor!, avatarName: userFromResponse.avatarName!, email: userFromResponse.email!, name: userFromResponse.name!)
        self.isLoggedIn = true
    }
    
    func createUser(user: User, completion: @escaping CompletionHandler) {
        
        let userContent = user.convertUserToStringDictionary(jsonEncoder: jsonEncoder)
        
        Alamofire.request(AddUser_Url, method: .post, parameters: userContent, encoding: JSONEncoding.default, headers: Bearer_Header).responseJSON { (response) in
            
            if response.result.error == nil {
                self.setUserInfo(response)
                completion(true)
            } else {
                completion(false)
                debugPrint(response.result.error as Any)
            }
        }
    }
    
    func findUserByEmail(completion: @escaping CompletionHandler) {
        
        Alamofire.request("\(User_By_Email_Url)\(userEmail)", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: Bearer_Header).responseJSON { (response) in
            
            if response.result.error == nil {
                self.setUserInfo(response)
                completion(true)
            } else {
                completion(false)
                debugPrint(response.result.error as Any)
            }
        }
    }
}























