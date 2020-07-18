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
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        super.viewDidLoad()
    }
    
    @IBAction func callButton(_ sender: Any) {
        if let phoneURL = URL(string: "tel://+905313376882") {
            if application.canOpenURL(phoneURL) {
                application.open(phoneURL, options: [:], completionHandler: nil)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func ozguryazılım(_ sender: Any) {
    }
    
    @IBAction func web(_ sender: Any) {
        guard let url = URL(string: "http://amasyaozguryazilim.com/") else { return }
        UIApplication.shared.open(url)
    }
    
    @IBAction func iletisim(_ sender: Any) {
        if let phoneURL = URL(string: "tel://+905355663188") {
            if application.canOpenURL(phoneURL) {
                application.open(phoneURL, options: [:], completionHandler: nil)
            }
        }
    }
    
    
    @IBAction func wp(_ sender: Any) {
        let urlWhats = "https://wa.me/+905313376882"
        https://wa.me/+905550563305
        if let urlString = urlWhats.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed) {
            if let whatsappURL = URL(string: urlString) {
                if UIApplication.shared.canOpenURL(whatsappURL) {
                    UIApplication.shared.openURL(whatsappURL)
                } else {
                    print("Install Whatsapp")
                }
            }
        }
    }
}
