//
//  specialOrderViewController.swift
//  CeliklerMarket
//
//  Created by Ahmet Yusuf TOĞTAY on 29.05.2020.
//  Copyright © 2020 OzguRND. All rights reserved.
//

import UIKit

class specialOrderViewController: UIViewController, UITextViewDelegate {

    
    @IBOutlet weak var specialOrderTextField: UITextView!
    
    override func viewDidLoad() {
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        super.viewDidLoad()
        specialOrderTextField.delegate = self
        specialOrderTextField.addDoneButton(title: "Bitti", target: self, selector: #selector(tapDone(sender:)))
    }
    
    @objc func tapDone(sender: Any) {
        self.view.endEditing(true)
    }
    
    func textViewShouldEndEditing(_ textView: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        specialOrderTextField.text = String()
    }
    
    @IBAction func SendMarket(_ sender: Any) {
        let alert = UIAlertController(title: "", message: "Siparişiniz Mağazamıza Ulaşmıştır.", preferredStyle: .alert)

        let action = UIAlertAction(title: "Tamam", style: .default, handler: { (action: UIAlertAction!) in
            //self.performSegue(withIdentifier: "goBackDelivery", sender: nil)
            //self.navigationController?.popToRootViewController(animated: true)
            self.performSegue(withIdentifier: "goBackSepecialOrder", sender: nil)
        })
        alert.addAction(action)
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
}

extension UITextView {
    
    func addDoneButton(title: String, target: Any, selector: Selector) {
        
        let toolBar = UIToolbar(frame: CGRect(x: 0.0,
                                              y: 0.0,
                                              width: UIScreen.main.bounds.size.width,
                                              height: 44.0))//1
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)//2
        let barButton = UIBarButtonItem(title: title, style: .plain, target: target, action: selector)//3
        toolBar.setItems([flexible, barButton], animated: false)//4
        self.inputAccessoryView = toolBar//5
    }
}
