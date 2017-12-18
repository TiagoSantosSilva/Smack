//
//  UserDataService.swift
//  Smack
//
//  Created by Tiago Santos on 14/12/17.
//  Copyright © 2017 Tiago Santos. All rights reserved.
//

import Foundation

class UserDataService {
    
    static let instance = UserDataService()
    
    public private(set) var id = ""
    public private(set) var avatarColor = ""
    public private(set) var avatarName = ""
    public private(set) var email = ""
    public private(set) var name = ""
    
    func setUserData(id: String, color: String, avatarName: String, email: String, name: String) {
        self.id = id
        self.avatarColor = color
        self.avatarName = avatarName
        self.email = email
        self.name = name
    }
    
    func setAvatarName(avatarName: String) {
        self.avatarName = avatarName
    }
    
    func returnUIColor(components: String) -> UIColor {
        
        let scanner = Scanner(string: components)
        let skipped = CharacterSet(charactersIn: "[], ")
        let comma = CharacterSet(charactersIn: ",")
        scanner.charactersToBeSkipped = skipped
        
        var red, green, blue, alpha : NSString?
        
        scanner.scanUpToCharacters(from: comma, into: &red)
        scanner.scanUpToCharacters(from: comma, into: &green)
        scanner.scanUpToCharacters(from: comma, into: &blue)
        scanner.scanUpToCharacters(from: comma, into: &alpha)
        
        let defaultColor = UIColor.lightGray
        
        guard let redUnwrapped = red else { return defaultColor }
        guard let greenUnwrapped = green else { return defaultColor }
        guard let blueUnwrapped = blue else { return defaultColor }
        guard let alphaUnwrapped = alpha else { return defaultColor }
        
        let color = UIColor(red: CGFloat(redUnwrapped.doubleValue), green: CGFloat(greenUnwrapped.doubleValue), blue: CGFloat(blueUnwrapped.doubleValue), alpha: CGFloat(alphaUnwrapped.doubleValue))
        
        return color
    }
    
    func logoutUser() {
        id = ""
        avatarColor = ""
        avatarName = ""
        email = ""
        name = ""
        AuthenticationService.instance.isLoggedIn = false
        AuthenticationService.instance.userEmail = ""
        AuthenticationService.instance.authenticationToken = ""
        MessageService.instance.clearChannels()
    }
}
