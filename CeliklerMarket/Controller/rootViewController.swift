//
//  rootViewController.swift
//  CeliklerMarket
//
//  Created by Ahmet Yusuf TOĞTAY on 16.06.2020.
//  Copyright © 2020 OzguRND. All rights reserved.
//

import UIKit

class rootViewController: UIViewController {
    
    var window: UIWindow?
    @IBOutlet weak var login: UIButton!
    @IBOutlet weak var devam: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        login.layer.cornerRadius = 6.0
        devam.layer.cornerRadius = 6.0
    }
    
    @IBAction func signIn(_ sender: Any) {
    }
    
    @IBAction func devam(_ sender: Any) {
    }
    
}
