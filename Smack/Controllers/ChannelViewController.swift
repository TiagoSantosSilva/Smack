//
//  ChannelViewController.swift
//  Smack
//
//  Created by Tiago Santos on 11/12/17.
//  Copyright © 2017 Tiago Santos. All rights reserved.
//

import UIKit

class ChannelViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.revealViewController().rearViewRevealWidth = self.view.frame.size.width - 60
    }
}