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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func closeButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: Unwind_To_Channel, sender: nil)
    }
    
    @IBAction func createAccountButtonPressed(_ sender: Any) {
        guard let email = emailTxt.text, emailTxt.text != "" else { return }
        guard let username = userNameTxt.text, userNameTxt.text != "" else { return }
        guard let password = passwordTxt.text, passwordTxt.text != "" else { return }
        
        let user = User( _id: nil, user: email, email: email, token: nil, password: password, avatarName: "profileDefault", avatarColor: "[0.5, 0.5, 0.5, 1]", name: username)
        
        AuthenticationService.instance.registerUser(user: user) { (registerSuccess) in
            if registerSuccess {
                AuthenticationService.instance.loginUser(user: user, completion: { (loginSuccess) in
                    if loginSuccess {
                        print("Logged in user.", AuthenticationService.instance.authenticationToken)
                        AuthenticationService.instance.createUser(user: user, completion: { (createUserSuccess) in
                            print("Created user.")
                            self.performSegue(withIdentifier: Unwind_To_Channel, sender: nil)
                        })
                    }
                })
            }
        }
    }
    
    @IBAction func generateBackgroundPressed(_ sender: Any) {
    }
    
    @IBAction func chooseAvatarPressed(_ sender: Any) {
        performSegue(withIdentifier: To_Avatar_Picker, sender: nil)
    }
}
