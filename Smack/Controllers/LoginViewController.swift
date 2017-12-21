//
//  LoginViewController.swift
//  Smack
//
//  Created by Tiago Santos on 12/12/17.
//  Copyright © 2017 Tiago Santos. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var closeButton: UIButton!
    
    @IBOutlet weak var userNameTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var progressSpinner: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        progressSpinner.isHidden = true
        // Do any additional setup after loading the view.
    }
    
    @IBAction func closeButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        progressSpinner.isHidden = false
        progressSpinner.startAnimating()
        
        guard let userName = userNameTxt.text, userNameTxt.text != "" else { return }
        guard let password = passwordTxt.text, passwordTxt.text != "" else { return }
        
        let user = User(_id: nil, user: nil, email: userName, token: nil, password: password, avatarName: nil, avatarColor: nil, name: userName)
        
        AuthenticationService.instance.loginUser(user: user) { (success) in
            if success {
                NotificationCenter.default.post(name: Notification_User_Data_Did_Change, object: nil)
                self.dismiss(animated: true, completion: nil)
            }
        }
        
        progressSpinner.isHidden = true
        progressSpinner.stopAnimating()
    }
    
    @IBAction func createAccountButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: To_Create_Account, sender: nil)
    }
    
    fileprivate func setupView() {
        userNameTxt.attributedPlaceholder = NSAttributedString(string: "username", attributes: [NSAttributedStringKey.foregroundColor : Smack_Purple_Place_Holder])
        passwordTxt.attributedPlaceholder = NSAttributedString(string: "password", attributes: [NSAttributedStringKey.foregroundColor : Smack_Purple_Place_Holder])
    }
}
