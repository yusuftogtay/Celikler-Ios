//
//  PhoneAuthController.swift
//  CeliklerMarket
//
//  Created by Ahmet Yusuf TOĞTAY on 11.05.2020.
//  Copyright © 2020 OzguRND. All rights reserved.
//

import UIKit
import FirebaseAuth

class PhoneAuthController: UIViewController {
    
    var phoneNumber = ""
    var verification_ID : String? = nil
   
    @IBOutlet weak var otpcode: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(sender:)), name: UIResponder.keyboardWillShowNotification, object: nil);

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(sender:)), name: UIResponder.keyboardWillHideNotification, object: nil);
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(gestureRecognizer)
    }
    
    @objc func hideKeyboard()   {
        view.endEditing(true)
    }
    @IBAction func signIn(_ sender: Any) {
        let credential = PhoneAuthProvider.provider().credential(withVerificationID: verification_ID!, verificationCode: otpcode.text!)
        Auth.auth().signIn(with: credential, completion: {authData, error in if (error != nil)  {
            error.debugDescription
        }   else{
            print(authData?.user.phoneNumber)
            }
            
        })
    }
    
    @objc func keyboardWillShow(sender: NSNotification) {
         self.view.frame.origin.y = -170 // Move view 150 points upward
    }
    
    @objc func keyboardWillHide(sender: NSNotification) {
         self.view.frame.origin.y = 0 // Move view to original position
    }
}
