//
//  ChannelViewController.swift
//  Smack
//
//  Created by Tiago Santos on 11/12/17.
//  Copyright © 2017 Tiago Santos. All rights reserved.
//

import UIKit

class ChannelViewController: UIViewController {
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var userImage: CircleImage!
    
    @IBAction func prepareForUnwind(segue: UIStoryboardSegue) { }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.revealViewController().rearViewRevealWidth = self.view.frame.size.width - 60
        createObserver()
    }
    
    func createObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(ChannelViewController.userDataDidChange(_:)), name: Notification_User_Data_Did_Change, object: nil)
    }
    
    @objc func userDataDidChange(_ notification: Notification){
        if AuthenticationService.instance.isLoggedIn {
            loginButton.setTitle(UserDataService.instance.name, for: .normal)
            userImage.image = UIImage(named: UserDataService.instance.avatarName)
            userImage.backgroundColor = UserDataService.instance.returnUIColor(components: UserDataService.instance.avatarColor)
            
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
}
