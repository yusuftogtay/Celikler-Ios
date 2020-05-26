//
//  ProductCollectionViewCell.swift
//  CeliklerMarket
//
//  Created by Ahmet Yusuf TOĞTAY on 19.05.2020.
//  Copyright © 2020 OzguRND. All rights reserved.
//

import UIKit

protocol ProductCollectionView {
    func oneClickCell(index: Int)
}

class ProductCollectionViewCell: UICollectionViewCell {
    
    var cellDelegate: ProductCollectionView?
    var index: IndexPath?
    
    var counter = 0
    
    @IBOutlet weak var unitLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var addbutton: UIButton!
    
    @IBAction func addButton(_ sender: Any) {
        if addbutton.titleLabel?.text == "Ekle" {
            addbutton.titleLabel?.text = "Güncelle"
        }
        cellDelegate?.oneClickCell(index: (index?.row)!)
    }
    @IBAction func minusButton(_ sender: Any) {
        if counter > 0  {
            counter -= 1
            unitLabel.text = String(counter)
        }
    }
    @IBAction func plusButton(_ sender: Any) {
        counter += 1
        unitLabel.text = String(counter)
    }
    
    
    
}