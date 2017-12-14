//
//  AvatarCollectionViewCell.swift
//  Smack
//
//  Created by Tiago Santos on 14/12/17.
//  Copyright © 2017 Tiago Santos. All rights reserved.
//

import UIKit

class AvatarCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var cellImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    func setupView() {
        self.layer.backgroundColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
    }
    
    func configureCell(index: Int, avatarType: AvatarType){
        switch avatarType{
        case .light:
            cellImage.image = UIImage(named: "light\(index)")
            self.layer.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        case .dark:
            cellImage.image = UIImage(named: "dark\(index)")
            self.layer.backgroundColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        }
    }
}
