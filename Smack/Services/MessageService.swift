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
    var messages = [Message]()
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
    
    func findAllMessagesForChannel(channelId: String, completion: @escaping CompletionHandler) {
        Alamofire.request("\(Messages_Url)\(channelId)", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: Bearer_Header).responseJSON { (response) in
            if response.result.error == nil {
                let messagesFromJson = convertStringDictionaryToMessageList(content: response.result.value, jsonDecoder: self.jsonDecoder)
                
                for message in messagesFromJson {
                    self.messages.append(message)
                }
                completion(true)
            } else {
                debugPrint(response.result.error as Any)
                completion(false)
            }
        }
    }
    
    func clearChannels() {
        channels.removeAll()
    }
    
    func clearMessages() {
        messages.removeAll()
    }
}
