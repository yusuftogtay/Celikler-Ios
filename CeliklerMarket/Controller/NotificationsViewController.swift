//
//  NotificationsViewController.swift
//  CeliklerMarket
//
//  Created by Ahmet Yusuf TOĞTAY on 2.06.2020.
//  Copyright © 2020 OzguRND. All rights reserved.
//

import UIKit

class NotificationsViewController: UIViewController {

    override func viewDidLoad() {
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
}
