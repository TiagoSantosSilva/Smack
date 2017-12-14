//
//  AvatarPickerViewController.swift
//  Smack
//
//  Created by Tiago Santos on 14/12/17.
//  Copyright © 2017 Tiago Santos. All rights reserved.
//

import UIKit

class AvatarPickerViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    var actualAvatarType = AvatarType.dark
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func segmentedControlTapped(_ sender: Any) {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            actualAvatarType = .dark
        case 1:
            actualAvatarType = .light
        default:
            actualAvatarType = .light
        }
        
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "avatarCell", for: indexPath) as? AvatarCollectionViewCell else { return AvatarCollectionViewCell() }
        cell.configureCell(index: indexPath.item, avatarType: actualAvatarType)
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 28
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var numberOfColumns : CGFloat = 3
        
        if UIScreen.main.bounds.width > 320 {
            numberOfColumns = 4
        }
        
        let spaceBetweenCells : CGFloat = 30
        let padding : CGFloat = 10
        
        let cellDimension = ((collectionView.bounds.width - padding) - (numberOfColumns - 1) * spaceBetweenCells) / numberOfColumns
        return CGSize(width: cellDimension, height: cellDimension)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch actualAvatarType {
        case .light:
            UserDataService.instance.setAvatarName(avatarName: "light\(indexPath.item)")
        case .dark:
            UserDataService.instance.setAvatarName(avatarName: "dark\(indexPath.item)")
        }
        
        self.dismiss(animated: true, completion: nil)
    }
}
