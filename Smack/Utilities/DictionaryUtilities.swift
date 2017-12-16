//
//  DictionaryUtilities.swift
//  Smack
//
//  Created by Tiago Santos on 15/12/17.
//  Copyright © 2017 Tiago Santos. All rights reserved.
//

// TODO: Change the functions in this class into a generic one.
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

func convertStringDictionaryToChannelList(content: Any?, jsonDecoder: JSONDecoder) -> [Channel] {
    
    let channelGuardReturn = [Channel]()
    
    guard let dictionary = content as? [String: Any] else { return channelGuardReturn }
    guard let json = try? JSONSerialization.data(withJSONObject: dictionary, options: []) else { return channelGuardReturn }
    
    do {
        let channels = try jsonDecoder.decode([Channel].self, from: json)
        return channels
    } catch let jsonError {
        print("Error serializing json: ", jsonError)
    }
    return channelGuardReturn
}
