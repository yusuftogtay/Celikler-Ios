//
//  ShoppingCardViewController.swift
//  CeliklerMarket
//
//  Created by Ahmet Yusuf TOĞTAY on 26.05.2020.
//  Copyright © 2020 OzguRND. All rights reserved.
//

import UIKit

class ShoppingCardViewController: UIViewController {
    
    @IBOutlet weak var cardClear: UIButton!
    @IBOutlet weak var cardsView: UICollectionView!
    @IBOutlet weak var productUnit: UILabel!
    @IBOutlet weak var total: UILabel!
    @IBOutlet weak var pay: UIButton!
    @IBOutlet weak var bagImage: UIImageView!
    @IBOutlet weak var cardEmptyInfo: UILabel!
    @IBOutlet weak var MainPageSegueButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        isEmptyCard()
        notEmptyCard()
    }
    
    func isEmptyCard() {
        cardClear.isHidden = true
        cardsView.isHidden = true
        productUnit.isHidden = true
        total.isHidden = true
        pay.isHidden = true
    }
    
    func notEmptyCard() {
        bagImage.isHidden = true
        cardEmptyInfo.isHidden = true
        MainPageSegueButton.isHidden = true
    }
    
    @IBAction func cardClear(_ sender: Any) {
    }
    
    @IBAction func pay(_ sender: Any) {
    }
    
    @IBAction func mainPageSegueButton(_ sender: Any) {
    }
}
