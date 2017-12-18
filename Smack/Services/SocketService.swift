//
//  SocketService.swift
//  Smack
//
//  Created by Tiago Santos on 16/12/17.
//  Copyright © 2017 Tiago Santos. All rights reserved.
//

import Foundation
import SocketIO

class SocketService: NSObject {
    
    static let instance = SocketService()
    
    override init() {
        super.init()
    }
    
    //var socket : SocketIOClient = SocketIOClient(socketURL: URL(string: Base_Url)!)
    var socket: SocketIOClient = SocketIOClient(socketURL: URL(string: Base_Url)!)
    
    func estabilishConnection() {
        socket.connect()
    }
    
    func closeConnection() {
        socket.disconnect()
    }
    
    func addChannel(channelName: String, channelDescription: String, completion: @escaping CompletionHandler) {
        socket.emit("newChannel", channelName, channelDescription)
        completion(true)
    }
    
    func getChannel(completion: @escaping CompletionHandler) {
        socket.on("channelCreated") { (dataArray, socketAckEmitter) in
            guard let channelName = dataArray[0] as? String else { return }
            guard let channelDescription = dataArray[1] as? String else { return }
            guard let channelId = dataArray[2] as? String else { return }
            
            let channel = Channel(id: channelId, name: channelName, description: channelDescription, version: nil)
            MessageService.instance.channels.append(channel)
            completion(true)
        }
    }
    
    func addMessage(messageBody: String, userId: String, channelId: String, completion: @escaping CompletionHandler) {
        let userDataService = UserDataService.instance
        socket.emit("newMessage", messageBody, userId, channelId, userDataService.name, userDataService.avatarName, userDataService.avatarColor)
        completion(true)
    }
}
