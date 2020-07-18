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
    var note: String = ""
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        print("Çok ram yiyor")
    }
    
    override func viewDidLoad() {
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        super.viewDidLoad()
        specialOrderTextField.delegate = self
        specialOrderTextField.addDoneButton(title: "Bitti", target: self, selector: #selector(tapDone(sender:)))
        specialDone.layer.cornerRadius = 6.0
    }
    
    @IBOutlet weak var specialDone: UIButton!
    @objc func tapDone(sender: Any) {
        self.view.endEditing(true)
    }
    
    private func textViewShouldEndEditing(_ textView: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        specialOrderTextField.text = String()
    }
    
    @IBAction func SendMarket(_ sender: Any) {
        let user : String? =  UserDefaults.standard.string(forKey: "username")
        if user != nil  {
            if specialOrderTextField.text == "Bir Şeyler Yazın" || specialOrderTextField.text == "" {
                let alert = UIAlertController(title: "Hata!", message: "Sipariş Alanı boş geçilmez", preferredStyle: .alert)

                let action = UIAlertAction(title: "Tamam", style: .default, handler: nil)
                alert.addAction(action)
                
                self.present(alert, animated: true, completion: nil)
            } else {
                note = specialOrderTextField.text
                UserDefaults.standard.set(note, forKey: "not")
                performSegue(withIdentifier: "goSpecialPay", sender: nil)
            }
        } else {
            let alert = UIAlertController(title: "Oturum Aç", message: "Sipariş verbilmeniz için oturum açmanız gerekmektedir.", preferredStyle: .alert)

            let action = UIAlertAction(title: "Tamam", style: .default, handler: { (action: UIAlertAction!) in
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "gologin", sender: nil)
                }
            })
            let cancel = UIAlertAction(title: "İptal Et", style: .cancel, handler: nil)
            alert.addAction(action)
            alert.addAction(cancel)
            
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goSpecialPay" {
            let destination = segue.destination as! paymentViewController
            destination.note = note
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
