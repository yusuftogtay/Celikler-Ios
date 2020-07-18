//
//  catCollectionViewCell.swift
//  CeliklerMarket
//
//  Created by Ahmet Yusuf TOĞTAY on 20.06.2020.
//  Copyright © 2020 OzguRND. All rights reserved.
//

import UIKit

protocol catCell {
    func catClick(index: IndexPath)
}

class catCollectionViewCell: UICollectionViewCell {
    
    var cellDelegate: catCell?
    var index: IndexPath?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //self.collectionView.selectItem(at: indexPath, animated: true, scrollPosition: UICollectionViewScrollPosition(rawValue: 0))
    }
    
    @IBOutlet weak var label: UILabel!
    override var isSelected: Bool{
        willSet{
            super.isSelected = newValue
            if newValue
            {
                //self.layer.backgroundColor = UIColor.white.cgColor
                self.backgroundColor = UIColor.white
                cellDelegate?.catClick(index: index!)
                
            }
            else
            {
                //36CE5A
                //let col1 = UIColor(red: 56, green: 212, blue: 90, alpha: 1)
                //self.layer.backgroundColor = col1.cgColor
                self.backgroundColor = UIColor.clear
            }
        }
    }
    
    func UIColorFromRGB(rgbValue: UInt) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}

