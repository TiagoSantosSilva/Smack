//
//  MessageCell.swift
//  Smack
//
//  Created by Tiago Santos on 18/12/17.
//  Copyright © 2017 Tiago Santos. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell {

    @IBOutlet weak var userImage: CircleImage!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var timeStampLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configureCell(message: Message) {
        messageLabel.text = message.messageBody
        userNameLabel.text = message.userName
        userImage.image = UIImage(named: message.userAvatar ?? "")
        userImage.backgroundColor = UserDataService.instance.returnUIColor(components: message.userAvatarColor!)
    }
}
