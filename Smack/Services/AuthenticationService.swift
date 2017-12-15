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
        
        let userContent = convertUserToStringDictionary(user: user)
        
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
        
        let userContent = convertUserToStringDictionary(user: user)
        
        Alamofire.request(Login_Url, method: .post, parameters: userContent, encoding: JSONEncoding.default, headers: Request_Header).responseJSON(completionHandler: { (response) in
            
            if response.result.error == nil {
                
                let userFromResponse = self.convertStringDictionaryToUser(content: response.result.value)
                
                guard let userEmail = userFromResponse.user else { return }
                guard let authenticationToken = userFromResponse.token else { return }
                
                self.userEmail = userEmail
                self.authenticationToken = authenticationToken
                
                print("Created user 🌞: \n \(user)")
                
                completion(true)
            } else {
                completion(false)
                debugPrint(response.result.error as Any)
            }
        })
    }
    
    func createUser(user: User, completion: @escaping CompletionHandler) {
        
        let userContent = convertUserToStringDictionary(user: user)
        
        Alamofire.request(AddUser_Url, method: .post, parameters: userContent, encoding: JSONEncoding.default, headers: AddUserRequest_Header).responseJSON { (response) in
            
            if response.result.error == nil {
                let userFromResponse = self.convertStringDictionaryToUser(content: response.result.value)
                
                print(userFromResponse)
                UserDataService.instance.setUserData(id: userFromResponse._id!, color: userFromResponse.avatarColor!, avatarName: userFromResponse.avatarName!, email: userFromResponse.email!, name: userFromResponse.name!)
                self.isLoggedIn = true
                completion(true)
            } else {
                completion(false)
                debugPrint(response.result.error as Any)
            }
        }
        
    }
    
    func convertStringDictionaryToUser(content: Any?) -> User {
        
        let userGuardReturn = User(_id: nil, user: nil, email: nil, token: nil, password: nil, avatarName: nil, avatarColor: nil, name: nil)
        
        guard let dict = content as? [String: Any] else { return userGuardReturn }
        guard let json = try? JSONSerialization.data(withJSONObject: dict, options: []) else { return userGuardReturn}
        
        do {
            let userFromDecode = try self.jsonDecoder.decode(User.self, from: json)
            return userFromDecode
        } catch let jsonError {
            print("Error serializing json: ", jsonError)
        }
        return userGuardReturn
    }
    
    func convertUserToStringDictionary(user: User) -> [String: Any] {
        
        let userAsJson = try! jsonEncoder.encode(user)
        let userJsonAsDictionary = try? JSONSerialization.jsonObject(with: userAsJson, options: []) as? [String: Any]
        
        guard let userAsDictionaryUnwrapped = userJsonAsDictionary! else { return [String: Any]() }
        return userAsDictionaryUnwrapped
    }
}
