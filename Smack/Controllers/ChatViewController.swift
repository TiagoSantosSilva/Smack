//
//  ChatViewController.swift
//  Smack
//
//  Created by Tiago Santos on 11/12/17.
//  Copyright © 2017 Tiago Santos. All rights reserved.
//

import UIKit

class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var channelNameLbl: UILabel!
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var sendMessageButton: UIButton!
    @IBOutlet weak var userTypingLbl: UILabel!
    
    var isTyping = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableViewAutomaticDimension
        sendMessageButton.isHidden = true
        setupView()
    }
    
    func setupView() {
        userTypingLbl.text = ""
        view.bindToKeyboard()
        createObservers()
        configureGestures()
        
        if AuthenticationService.instance.isLoggedIn {
            AuthenticationService.instance.findUserByEmail(completion: { (success) in
                NotificationCenter.default.post(name: Notification_User_Data_Did_Change, object: nil)
            })
        }
        
        listenForMessageInsertedInChat()
        listenToTypingUsers()
    }
    
    fileprivate func updateTypingUsersLabelVerbose(_ numberOfTypers: Int, _ names: String) {
        if numberOfTypers > 0 && AuthenticationService.instance.isLoggedIn == true {
            var verb = "is"
            if numberOfTypers > 1 {
                verb = "are"
            }
            self.userTypingLbl.text = "\(names) \(verb) typing a message"
        } else {
            self.userTypingLbl.text = ""
        }
    }
    
    fileprivate func listenForMessageInsertedInChat() {
        SocketService.instance.getChatMessage { (success) in
            self.tableView.reloadData()
            
            if MessageService.instance.messages.count > 0 {
                let endIndex = IndexPath(row: MessageService.instance.messages.count - 1, section: 0)
                self.tableView.scrollToRow(at: endIndex, at: .bottom, animated: false)
            }
        }
    }
    
    fileprivate func addUsersToTypingUsersLabel(_ typingUsers: ([String : String]), _ channelId: String, _ names: inout String, _ numberOfTypers: inout Int) {
        for (typingUser, channel) in typingUsers {
            if typingUser != UserDataService.instance.name && channel == channelId {
                if names == "" {
                    names = typingUser
                } else {
                    names = "\(names), \(typingUser)"
                }
                numberOfTypers += 1
            }
        }
    }
    
    func listenToTypingUsers() {
        SocketService.instance.getTypingUsers { (typingUsers) in
            guard let channelId = MessageService.instance.selectedChannel?.id else { return }
            var names = ""
            var numberOfTypers = 0
            
            self.addUsersToTypingUsersLabel(typingUsers, channelId, &names, &numberOfTypers)
            self.updateTypingUsersLabelVerbose(numberOfTypers, names)
        }
    }
    
    func configureGestures() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(ChatViewController.handleTap))
        view.addGestureRecognizer(tap)
        menuButton.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
    }
    
    @objc func handleTap() {
        view.endEditing(true)
    }
    
    func createObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(ChatViewController.userDataDidChange(_:)), name: Notification_User_Data_Did_Change, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ChatViewController.channelSelected(_:)), name: Notification_Channel_Selected, object: nil)
    }
    
    @objc func userDataDidChange(_ notification: Notification) {
        if AuthenticationService.instance.isLoggedIn {
            onLoginGetMessages()
        } else {
            channelNameLbl.text = "Please Log In"
            tableView.reloadData()
        }
    }
    
    @objc func channelSelected(_ notification: Notification) {
        updateWithChannel()
    }
    
    func updateWithChannel() {
        let channelName = MessageService.instance.selectedChannel?.name ?? ""
        channelNameLbl.text = "#\(channelName)"
        getMessages()
    }
    
    func onLoginGetMessages() {
        MessageService.instance.findAllChannels { (success) in
            if success {
                if MessageService.instance.channels.count > 0 {
                    MessageService.instance.selectedChannel = MessageService.instance.channels[0]
                    self.updateWithChannel()
                } else {
                    self.channelNameLbl.text = "No channels yet!"
                }
            }
        }
    }
    
    func getMessages() {
        guard let channelId = MessageService.instance.selectedChannel?.id else { return }
        MessageService.instance.findAllMessagesForChannel(channelId: channelId) { (success) in
            self.tableView.reloadData()
        }
    }
    
    @IBAction func sendButtonTapped(_ sender: Any) {
        if AuthenticationService.instance.isLoggedIn {
            guard let channelId = MessageService.instance.selectedChannel?.id else { return }
            guard let message = messageTextField.text else { return }
            
            SocketService.instance.addMessage(messageBody: message, userId: UserDataService.instance.id, channelId: channelId, completion: { (success) in
                self.messageTextField.text = ""
                self.messageTextField.resignFirstResponder()
            })
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "messageCell", for: indexPath) as? MessageCell else { return UITableViewCell() }
        let message = MessageService.instance.messages[indexPath.row]
        cell.configureCell(message: message)
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MessageService.instance.messages.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    @IBAction func messageTextFieldEditing(_ sender: Any) {
        guard let channelId = MessageService.instance.selectedChannel?.id else { return }
        
        if messageTextField.text == "" {
            isTyping = false
            sendMessageButton.isHidden = true
            SocketService.instance.socket.emit("stopType", channelId)
        } else {
            if isTyping == false {
                sendMessageButton.isHidden = false
                SocketService.instance.socket.emit("startType", channelId)
            }
            isTyping = true
        }
    }
    
}
