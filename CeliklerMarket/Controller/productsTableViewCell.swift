//
//  productsTableViewCell.swift
//  CeliklerMarket
//
//  Created by Ahmet Yusuf TOĞTAY on 4.06.2020.
//  Copyright © 2020 OzguRND. All rights reserved.
//

import UIKit
import SDWebImage

protocol productCell {
    func onClickCell(index: Int , unit: String, indexPath: IndexPath)
}

class productsTableViewCell: UITableViewCell {
    
    var cellDelegate: productCell?
    var index: IndexPath?
    var tapGestureRecognizer = UITapGestureRecognizer()
    
    
    @IBOutlet weak var unit: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func minus(_ sender: Any) {
        if (unit.text?.contains("."))! {
            let u = "\(Double(unit.text!) ?? 0)"
            if Double(u)! == 0.0 {
                unit.text = "0.0"
            } else if Double(u)! == 0.5 {
                unit.text = "0.5"
            } else {
                unit.text = "\( Double(round(10*(Double(u)! - 0.1))/10))"
            }
        } else {
            if Int(unit.text!)! > 0 {
                let u = "\(Int(unit.text!) ?? 0)"
                unit.text = "\(Int(u)! - 1)"
            }
        }
        let a = unit.text!
        let sayi = Double(a)!
        if sayi > 0 {
            let p = price.text!.components(separatedBy: "₺")
            let priceInt = Double(p[0])
            total.text = "Toplam: \(Double(round(100*(Double(priceInt!) * Double(unit.text!)!))/100))₺"
            cellDelegate?.onClickCell(index: (index?.row)!, unit: unit.text!, indexPath: index!)
        }
    }
    
    @IBAction func plus(_ sender: Any) {
        if (unit.text?.contains("."))! {
            let u = "\(Double(unit.text!) ?? 0)"
            if Double(u)! < 1 {
                unit.text = "1.0"
            } else {
                unit.text = "\(Double(round(10*(Double(u)! + 0.1))/10))"
            }
        } else {
            let u = "\(Int(unit.text!) ?? 0)"
            unit.text = "\(Int(u)! + 1)"
        }
        let a = unit.text!
        let sayi = Double(a)!
        if sayi > 0 {
            let p = price.text!.components(separatedBy: "₺")
            let priceInt = Double(p[0])
            total.text = "Toplam: \(Double(round(100*(Double(priceInt!) * Double(unit.text!)!))/100))₺"
            cellDelegate?.onClickCell(index: (index?.row)!, unit: unit.text!, indexPath: index!)
        }
    }
    
    @IBAction func button(_ sender: Any) {
        let a = unit.text!
        let sayi = Double(a)!
        if sayi > 0 {
            let p = price.text!.components(separatedBy: "₺")
            let priceInt = Double(p[0])
            total.text = "Toplam: \(Double(round(100*(Double(priceInt!) * Double(unit.text!)!))/100))₺"
            cellDelegate?.onClickCell(index: (index?.row)!, unit: unit.text!, indexPath: index!)
        }
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBOutlet weak var yeniprice: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var total: UILabel!
}
