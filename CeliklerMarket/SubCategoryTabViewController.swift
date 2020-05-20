//
//  SubCategoryTabViewController.swift
//  CeliklerMarket
//
//  Created by Ahmet Yusuf TOĞTAY on 15.05.2020.
//  Copyright © 2020 OzguRND. All rights reserved.
//

import UIKit

class SubCategoryTabViewController: UITabBarController {

    var subCategoryID = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
    }
    func setupTabBar()  {
        let subCategoryViewController = UINavigationController(rootViewController: SubCategoryViewController())
        subCategoryViewController.tabBarItem.title = "Deneme"
        let deneme = UINavigationController(rootViewController: denemeViewController())
        deneme.tabBarItem.title = "Deneme2"
    }
}
