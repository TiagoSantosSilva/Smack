//
//  Channel.swift
//  Smack
//
//  Created by Tiago Santos on 16/12/17.
//  Copyright © 2017 Tiago Santos. All rights reserved.
//

import Foundation

struct Channel: Codable {
    
    let id: String?
    let name: String?
    let description: String?
    let version: Int?
    
    enum CodingKeys : String, CodingKey {
        case id = "_id"
        case name = "name"
        case description = "description"
        case version = "__v"
    }
}
