//
//  accountViewController.swift
//  CeliklerMarket
//
//  Created by Ahmet Yusuf TOĞTAY on 7.06.2020.
//  Copyright © 2020 OzguRND. All rights reserved.
//

import UIKit
import Firebase

class accountViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        address.layer.cornerRadius = 6.0
        info.layer.cornerRadius = 6.0
        logout.layer.cornerRadius = 6.0
        // Do any additional setup after loading the view.
    }
    @IBOutlet weak var address: UIButton!
    @IBOutlet weak var logout: UIButton!
    @IBAction func informations(_ sender: Any) {
    }
    @IBAction func logout(_ sender: Any) {
        let auth = Auth.auth()
         let delegate : AppDelegate = UIApplication.shared.delegate as! AppDelegate
        do {
            try auth.signOut()
            UserDefaults.standard.removeObject(forKey:"username")
            UserDefaults.standard.synchronize()
            delegate.romoveUser()
        } catch {
            print("Error")
        }
        
    }
    
    @IBOutlet weak var info: UIButton!
}

extension UIViewController {
  func alert(message: String, title: String = "") {
    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
    alertController.addAction(OKAction)
    self.present(alertController, animated: true, completion: nil)
  }
}
