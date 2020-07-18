//
//  catCollectionViewCell.swift
//  CeliklerMarket
//
//  Created by Ahmet Yusuf TOĞTAY on 20.06.2020.
//  Copyright © 2020 OzguRND. All rights reserved.
//

import UIKit

class catCollectionViewCell: UICollectionViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBOutlet weak var label: UILabel!
    override var isSelected: Bool{
        willSet{
            super.isSelected = newValue
            if newValue
            {
                self.backgroundColor = UIColor.white
            }
            else
            {
                self.backgroundColor = UIColor.clear
            }
        }
    }
}
