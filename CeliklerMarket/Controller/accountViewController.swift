//
//  accountViewController.swift
//  CeliklerMarket
//
//  Created by Ahmet Yusuf TOĞTAY on 7.06.2020.
//  Copyright © 2020 OzguRND. All rights reserved.
//

import UIKit

class accountViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        address.layer.cornerRadius = 6.0
        info.layer.cornerRadius = 6.0
        // Do any additional setup after loading the view.
    }
    @IBOutlet weak var address: UIButton!
    @IBAction func informations(_ sender: Any) {
    }
    
    @IBOutlet weak var info: UIButton!
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
