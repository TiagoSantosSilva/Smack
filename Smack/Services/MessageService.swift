//
//  MessageService.swift
//  Smack
//
//  Created by Tiago Santos on 16/12/17.
//  Copyright © 2017 Tiago Santos. All rights reserved.
//

import Foundation
import Alamofire

class MessageService {
    
    var jsonDecoder: JSONDecoder
    
    init() {
        jsonDecoder = JSONDecoder()
    }
    
    static let instance = MessageService()
    
    var channels = [Channel]()
    var selectedChannel: Channel?
    
    func findAllChannels(completion: @escaping CompletionHandler) {
        Alamofire.request(Channels_Url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: Bearer_Header).responseJSON { (response) in
            
            if response.result.error == nil {
                let channelsFromJson = convertStringDictionaryToChannelList(content: response.result.value, jsonDecoder: self.jsonDecoder)
                
                for channel in channelsFromJson {
                    self.channels.append(channel)
                }
                
                NotificationCenter.default.post(name: Notification_Channels_Loaded, object: nil)
                completion(true)
            } else {
                completion(false)
                debugPrint(response.result.error as Any)
            }
        }
    }
    
    func clearChannels() {
        channels.removeAll()
    }
}
