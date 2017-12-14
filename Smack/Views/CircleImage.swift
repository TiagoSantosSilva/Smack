//
//  CircleImage.swift
//  Smack
//
//  Created by Tiago Santos on 14/12/17.
//  Copyright © 2017 Tiago Santos. All rights reserved.
//

import UIKit

@IBDesignable
class CircleImage: UIImageView {
    
    
    override func awakeFromNib() {
        setupView()
    }
    
    func setupView(){
        self.layer.cornerRadius = self.frame.width / 2 // <- Perfect circle.
        self.clipsToBounds = true
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setupView()
    }
}
