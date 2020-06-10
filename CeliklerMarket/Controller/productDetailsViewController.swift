//
//  productDetailsViewController.swift
//  CeliklerMarket
//
//  Created by Ahmet Yusuf TOĞTAY on 10.06.2020.
//  Copyright © 2020 OzguRND. All rights reserved.
//

import UIKit
import SDWebImage

class productDetailsViewController: UIViewController {

    var image = ""
    var details = ""
    var name = ""
    var productid = ""
    

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var imageLabel: UIImageView!
    @IBOutlet weak var detail: UILabel!
    let placeHolderImage = UIImage(named: "V1")

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        let imageUrl = URL(string: "https://amasyaceliklermarket.com" + image)
        imageLabel.sd_setImage(with: imageUrl, placeholderImage: placeHolderImage, options: SDWebImageOptions.highPriority, context: nil)
        nameLabel.text = name
        detail.text = details
    }
}
