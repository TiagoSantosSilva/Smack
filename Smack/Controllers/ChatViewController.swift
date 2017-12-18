//
//  ChatViewController.swift
//  Smack
//
//  Created by Tiago Santos on 11/12/17.
//  Copyright © 2017 Tiago Santos. All rights reserved.
//

import UIKit

class ChatViewController: UIViewController {
    
    @IBOutlet weak var menuButton: UIButton!
    
    @IBOutlet weak var channelNameLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        menuButton.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        
        createObserver()
        
        if AuthenticationService.instance.isLoggedIn {
            AuthenticationService.instance.findUserByEmail(completion: { (success) in
                NotificationCenter.default.post(name: Notification_User_Data_Did_Change, object: nil)
            })
        }
    }
    
    func createObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(ChatViewController.userDataDidChange(_:)), name: Notification_User_Data_Did_Change, object: nil)
    }
    
    @objc func userDataDidChange(_ notification: Notification) {
        if AuthenticationService.instance.isLoggedIn {
            onLoginGetMessages()
        } else {
            channelNameLbl.text = "Please Log In"
        }
    }
    
    func onLoginGetMessages() {
        MessageService.instance.findAllChannels { (success) in
            if success {
                // Do something with channels
            }
        }
    }
}
