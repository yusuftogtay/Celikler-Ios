//
//  productsTableViewCell.swift
//  CeliklerMarket
//
//  Created by Ahmet Yusuf TOĞTAY on 4.06.2020.
//  Copyright © 2020 OzguRND. All rights reserved.
//

import UIKit

protocol productCell {
    func onClickCell(index: Int , unit: String)
    
}

class productsTableViewCell: UITableViewCell {
    
    var cellDelegate: productCell?
    var index: IndexPath?

    @IBOutlet weak var unit: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    @IBAction func minus(_ sender: Any) {
        let u = "\(Int(unit.text!) ?? 0)"
        if Int(u)! > 0    {
            unit.text = "\(Int(u)! - 1)"
        }
    }
    
    @IBAction func plus(_ sender: Any) {
        let u = "\(Int(unit.text!) ?? 0)"
        unit.text = "\(Int(u)! + 1)"
    }
    
    @IBAction func button(_ sender: Any) {
        if unit.text != "0"  {
            cellDelegate?.onClickCell(index: (index?.row)!, unit: unit.text!)
            print(price.text! + "deneme ")
            var p = price.text!.components(separatedBy: "₺")
            print(p)
            print(p[0])
            let priceInt = Double(p[0])
            
            total.text = "Toplam: \(Double(round(100*(Double(priceInt!) * Double(unit.text!)!))/100))₺"
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBOutlet weak var yeniprice: UILabel!
    
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var total: UILabel!
}
