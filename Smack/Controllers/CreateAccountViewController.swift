//
//  CreateAccountViewController.swift
//  Smack
//
//  Created by Tiago Santos on 13/12/17.
//  Copyright © 2017 Tiago Santos. All rights reserved.
//

import UIKit

class CreateAccountViewController: UIViewController {
    
    @IBOutlet weak var userNameTxt: UITextField!
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var userImage: UIImageView!
    
    @IBOutlet weak var chooseAvatarButton: UIButton!
    @IBOutlet weak var generateBackgroundButton: UIButton!
    @IBOutlet weak var createAccountButton: UIButton!
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    var avatarName = "profileDefault"
    var avatarColor = "[0.5, 0.5, 0.5, 1]"
    var backgroundColor: UIColor?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if UserDataService.instance.avatarName != "" {
            userImage.image = UIImage(named: UserDataService.instance.avatarName)
            avatarName = UserDataService.instance.avatarName
            
            if avatarName.contains("light") && backgroundColor == nil {
                backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
            }
        }
    }
    
    @IBAction func closeButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: Unwind_To_Channel, sender: nil)
    }
    
    @IBAction func createAccountButtonPressed(_ sender: Any) {
        spinner.isHidden = false
        spinner.startAnimating()
        
        guard let email = emailTxt.text, emailTxt.text != "" else { return }
        guard let username = userNameTxt.text, userNameTxt.text != "" else { return }
        guard let password = passwordTxt.text, passwordTxt.text != "" else { return }
        
        let user = User( _id: nil, user: email, email: email, token: nil, password: password, avatarName: avatarName, avatarColor: avatarColor, name: username)
        
        AuthenticationService.instance.registerUser(user: user) { (registerSuccess) in
            if registerSuccess {
                AuthenticationService.instance.loginUser(user: user, completion: { (loginSuccess) in
                    if loginSuccess {
                        print("Logged in user.", AuthenticationService.instance.authenticationToken)
                        AuthenticationService.instance.createUser(user: user, completion: { (createUserSuccess) in
                            if createUserSuccess {
                                self.spinner.isHidden = true
                                self.spinner.stopAnimating()
                                
                                print("Created user.")
                                self.performSegue(withIdentifier: Unwind_To_Channel, sender: nil)
                                NotificationCenter.default.post(name: Notification_User_Data_Did_Change, object: nil)
                            }
                        })
                    }
                })
            }
        }
    }
    
    @IBAction func generateBackgroundPressed(_ sender: Any) {
        let red = CGFloat(arc4random_uniform(255)) / 255
        let green = CGFloat(arc4random_uniform(255)) / 255
        let blue = CGFloat(arc4random_uniform(255)) / 255
        
        backgroundColor = UIColor(red: red, green: green, blue: blue, alpha: 1.0)
        avatarColor = "[\(red), \(green), \(blue), 1]"
        UIView.animate(withDuration: 0.3) {
            self.userImage.backgroundColor = self.backgroundColor
        }
    }
    
    @IBAction func chooseAvatarPressed(_ sender: Any) {
        self.performSegue(withIdentifier: To_Avatar_Picker, sender: nil)
    }
    
    func setupView() {
        
        spinner.isHidden = true
        
        userNameTxt.attributedPlaceholder = NSAttributedString(string: "username", attributes: [NSAttributedStringKey.foregroundColor: Smack_Purple_Place_Holder])
        emailTxt.attributedPlaceholder = NSAttributedString(string: "email", attributes: [NSAttributedStringKey.foregroundColor: Smack_Purple_Place_Holder])
        passwordTxt.attributedPlaceholder = NSAttributedString(string: "password", attributes: [NSAttributedStringKey.foregroundColor: Smack_Purple_Place_Holder])
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tap)
    }
    
    @objc func handleTap() {
        view.endEditing(true)
    }
}
