//
//  ChannelViewController.swift
//  Smack
//
//  Created by Tiago Santos on 11/12/17.
//  Copyright © 2017 Tiago Santos. All rights reserved.
//

import UIKit

class ChannelViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var userImage: CircleImage!
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func prepareForUnwind(segue: UIStoryboardSegue) { }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.revealViewController().rearViewRevealWidth = self.view.frame.size.width - 60
        tableView.delegate = self
        tableView.dataSource = self
        createObserver()
        
        SocketService.instance.getChannel { (success) in
            self.tableView.reloadData()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        verifyUserStatus()
    }
    
    func createObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(ChannelViewController.userDataDidChange(_:)), name: Notification_User_Data_Did_Change, object: nil)
    }
    
    @objc func userDataDidChange(_ notification: Notification){
        verifyUserStatus()
    }
    
    @IBAction func addChannelTapped(_ sender: Any) {
        let addChannelVC = AddChannelViewController()
        addChannelVC.modalPresentationStyle = .custom
        present(addChannelVC, animated: true, completion: nil)
    }
    
    func verifyUserStatus() {
        if AuthenticationService.instance.isLoggedIn {
            AuthenticationService.instance.findUserByEmail(completion: { (success) in
                self.loginButton.setTitle(UserDataService.instance.name, for: .normal)
                self.userImage.image = UIImage(named: UserDataService.instance.avatarName)
                self.userImage.backgroundColor = UserDataService.instance.returnUIColor(components: UserDataService.instance.avatarColor)
            })
        } else {
            loginButton.setTitle("Login", for: .normal)
            userImage.image = UIImage(named: "profileDefault")
            userImage.backgroundColor = UIColor.clear
        }
    }
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        
        if AuthenticationService.instance.isLoggedIn {
            let profileViewController = ProfileViewController()
            profileViewController.modalPresentationStyle = .custom
            present(profileViewController, animated: true, completion: nil)
        } else {
            performSegue(withIdentifier: To_Login, sender: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "channelCell", for: indexPath) as? ChannelCell else { return UITableViewCell() }
        
        let channel = MessageService.instance.channels[indexPath.row]
        cell.configureCell(channel: channel)
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MessageService.instance.channels.count
    }
}








