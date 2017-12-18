//
//  ChannelCell.swift
//  Smack
//
//  Created by Tiago Santos on 16/12/17.
//  Copyright © 2017 Tiago Santos. All rights reserved.
//

import UIKit

@IBDesignable
class ChannelCell: UITableViewCell {

    @IBOutlet weak var channelName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        if selected {
            self.layer.backgroundColor = UIColor(white: 1, alpha: 0.2).cgColor
        } else {
            self.layer.backgroundColor = UIColor.clear.cgColor
        }
    }
    
    func configureCell(channel: Channel) {
        channelName.text = ("#\(channel.name ?? "")")
        channelName.font = UIFont(name: "Avenir-Book", size: 17)
        
        for channelId in MessageService.instance.unreadChannels {
            if channel.id == channelId {
                channelName.font = UIFont(name: "Avenir-Heavy", size: 20)
            }
        }
    }
}
