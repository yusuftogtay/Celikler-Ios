//
//  ViewController.swift
//  CeliklerMarket
//
//  Created by Ahmet Yusuf TOĞTAY on 1.05.2020.
//  Copyright © 2020 OzguRND. All rights reserved.
//

import UIKit
import FirebaseCore
import FirebaseAuth

class ViewController: UIViewController {
    
    var verification_id : String? = nil
    var phoneNumber = ""
    
    @IBOutlet weak var otpTextField: UITextField!
    @IBOutlet var keyboardHeightLayoutConstraint: NSLayoutConstraint?
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var infoLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        otpTextField.isHidden = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(sender:)), name: UIResponder.keyboardWillShowNotification, object: nil);
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(sender:)), name: UIResponder.keyboardWillHideNotification, object: nil);
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(gestureRecognizer)
    }
    
    @IBAction func phoneAuthClicked(_ sender: Any) {
        if (self.otpTextField.isHidden)  {
            if (!phoneNumberTextField.text!.isEmpty) {
                self.phoneNumberTextField.isHidden = true
                self.otpTextField.isHidden = false
                phoneNumber = phoneNumberTextField.text!
                PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil, completion: {
                    VerificationID, error in if(error != nil)   {
                        return
                    }   else    {
                        self.verification_id = VerificationID
                    }
                })
            }   else    {
                print("Lütfen Telefon Numaranızı Girin")
            }
        } else    {
            if verification_id != nil   {
                //infoLabel.text = "Cep Telefonuna gelen 6 haneli kodu girin"
                Auth.auth().settings?.isAppVerificationDisabledForTesting = false
                let credential = PhoneAuthProvider.provider().credential(withVerificationID: verification_id!, verificationCode: otpTextField.text!)
                Auth.auth().signIn(with: credential, completion: {
                    authData, error in
                    if error != nil {
                        print(error.debugDescription)
                    }   else    {
                        UserDefaults.standard.set(self.phoneNumberTextField.text!, forKey: "username")
                        UserDefaults.standard.synchronize()
                        let delegate : AppDelegate = UIApplication.shared.delegate as! AppDelegate
                        delegate.rememberUser()
                    }
                })
            }
        }
    }
    
    @objc func hideKeyboard()   {
        view.endEditing(true)
    }
    
    @objc func keyboardWillShow(sender: NSNotification) {
         self.view.frame.origin.y = -170 // Move view 150 points upward
    }
    
    @objc func keyboardWillHide(sender: NSNotification) {
         self.view.frame.origin.y = 0 // Move view to original position
    }
}

