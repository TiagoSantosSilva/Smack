//
//  UserExtension.swift
//  Smack
//
//  Created by Tiago Santos on 15/12/17.
//  Copyright © 2017 Tiago Santos. All rights reserved.
//

import Foundation

extension User {
    
    func convertUserToStringDictionary(jsonEncoder: JSONEncoder) -> [String: Any] {
        
        let userAsJson = try! jsonEncoder.encode(self)
        let userJsonAsDictionary = try? JSONSerialization.jsonObject(with: userAsJson, options: []) as? [String: Any]
        
        guard let userAsDictionaryUnwrapped = userJsonAsDictionary! else { return [String: Any]() }
        return userAsDictionaryUnwrapped
    }
}
