//
//  ContactViewController.swift
//  CeliklerMarket
//
//  Created by Ahmet Yusuf TOĞTAY on 8.06.2020.
//  Copyright © 2020 OzguRND. All rights reserved.
//

import UIKit

class ContactViewController: UIViewController {
    fileprivate let application = UIApplication.shared

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func callButton(_ sender: Any) {
        if let phoneURL = URL(string: "tel://+905550563305") {
            if application.canOpenURL(phoneURL) {
                application.open(phoneURL, options: [:], completionHandler: nil)
            }
        }
    }
}
