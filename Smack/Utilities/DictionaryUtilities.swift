//
//  DictionaryUtilities.swift
//  Smack
//
//  Created by Tiago Santos on 15/12/17.
//  Copyright © 2017 Tiago Santos. All rights reserved.
//

import Foundation

func convertStringDictionaryToUser(content: Any?, jsonDecoder: JSONDecoder) -> User {
    
    let userGuardReturn = User(_id: nil, user: nil, email: nil, token: nil, password: nil, avatarName: nil, avatarColor: nil, name: nil)
    
    guard let dict = content as? [String: Any] else { return userGuardReturn }
    guard let json = try? JSONSerialization.data(withJSONObject: dict, options: []) else { return userGuardReturn}
    
    do {
        let userFromDecode = try jsonDecoder.decode(User.self, from: json)
        return userFromDecode
    } catch let jsonError {
        print("Error serializing json: ", jsonError)
    }
    return userGuardReturn
}
