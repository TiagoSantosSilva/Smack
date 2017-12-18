//
//  Message.swift
//  Smack
//
//  Created by Tiago Santos on 18/12/17.
//  Copyright © 2017 Tiago Santos. All rights reserved.
//

import Foundation

struct Message: Codable {
    
    let id: String?
    let messageBody: String?
    let userId: String?
    let channelId: String?
    let userName: String?
    let userAvatar: String?
    let userAvatarColor: String?
    let version: Int?
    let timeStamp: String?
    
    enum CodingKeys : String, CodingKey {
        case id = "id"
        case messageBody = "messageBody"
        case userId = "userId"
        case channelId = "channelId"
        case userName = "userName"
        case userAvatar = "userAvatar"
        case userAvatarColor = "userAvatarColor"
        case version = "__v"
        case timeStamp = "timeStamp"
    }
}
