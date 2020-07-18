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

    var window: UIWindow?
    
    override func viewDidLoad() {
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        super.viewDidLoad()
        address.layer.cornerRadius = 6.0
        info.layer.cornerRadius = 6.0
        logout.layer.cornerRadius = 6.0
        login.layer.cornerRadius = 6.0
        let user : String? =  UserDefaults.standard.string(forKey: "username")
        if user != nil  {
            address.isHidden = false
            logout.isHidden = false
            info.isHidden = false
            login.isHidden = true
        } else {
            address.isHidden = true
            logout.isHidden = true
            info.isHidden = true
            login.isHidden = false
        }
    }
    @IBOutlet weak var address: UIButton!
    @IBOutlet weak var logout: UIButton!
    @IBAction func informations(_ sender: Any) {
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    @IBOutlet weak var login: UIButton!
    
    @IBAction func login(_ sender: Any) {
        let board  : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let tabbar =  board.instantiateViewController(withIdentifier: "signInController")
        window?.rootViewController = tabbar
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
            #if DEBUG
                print(error)
            #endif
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
