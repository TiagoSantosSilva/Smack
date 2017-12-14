//
//  Constants.swift
//  Smack
//
//  Created by Tiago Santos on 12/12/17.
//  Copyright © 2017 Tiago Santos. All rights reserved.
//

import Foundation

// Colors

let Smack_Purple_Place_Holder = #colorLiteral(red: 0.3254901961, green: 0.4196078431, blue: 0.7764705882, alpha: 0.5)

// Segues

let To_Login = "toLogin"
let To_Create_Account = "toCreateAccount"
let To_Avatar_Picker = "toAvatarPicker"
let Unwind_To_Channel = "unwindToChannel"

// User Defaults

let Token_Key = "token"
let Logged_In_Key = "loggedIn"
let User_Email = "userEmail"


// Typealias is a way to rename a type. Ex: typealias Tiago = String ; let something: Tiago = "something"
typealias CompletionHandler = (_ Success: Bool) -> ()


// URL

let Base_Url = "http://localhost:3005/v1/"
let Register_Url = "\(Base_Url)account/register"
let Login_Url = "\(Base_Url)account/login"
let AddUser_Url = "\(Base_Url)user/add"

// Headers


let Request_Header = [
"Content-Type": "application/json; charset=utf-8"
]

let AddUserRequest_Header = [
    "Authorization": "Bearer \(AuthenticationService.instance.authenticationToken)",
    "Content-Type": "application/json; charset=utf-8"
]
