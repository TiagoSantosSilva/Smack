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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        menuButton.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        
        if AuthenticationService.instance.isLoggedIn {
            AuthenticationService.instance.findUserByEmail(completion: { (success) in
                NotificationCenter.default.post(name: Notification_User_Data_Did_Change, object: nil)
            })
        }
    }
}
