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
    var fcmToken: String?
    
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
    
    func alertPhoneNumber(status: String)   {
        if status == "isEmpty" {
            let alert = UIAlertController(title: "Hata!", message: "Telefon Numaranızı Girmediniz.", preferredStyle: .alert)

            let action = UIAlertAction(title: "Tamam", style: .default, handler: nil)
            alert.addAction(action)
            
            self.present(alert, animated: true, completion: nil)
        }   else if status == "isOtpEmpty" {
            let alert = UIAlertController(title: "Hata!", message: "Lütfen Güvenlik Kodunu Girin.", preferredStyle: .alert)

            let action = UIAlertAction(title: "Tamam", style: .default, handler: nil)
            alert.addAction(action)
            
            self.present(alert, animated: true, completion: nil)
        }   else {
            let alert = UIAlertController(title: "Hata!", message: "Telefon Numaranızı Eksik veya yanlış girdiniz.", preferredStyle: .alert)

            let action = UIAlertAction(title: "Tamam", style: .default, handler: nil)
            alert.addAction(action)
            
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
    @IBAction func phoneAuthClicked(_ sender: Any) {
        if (self.otpTextField.isHidden)  {
            if (!phoneNumberTextField.text!.isEmpty) {
                if (phoneNumberTextField.text?.count == 10)  {
                    phoneNumber = "+90" + phoneNumberTextField.text!
                } else if (phoneNumberTextField.text?.count == 11) {
                    phoneNumber = "+9" + phoneNumberTextField.text!
                } else if (phoneNumberTextField.text?.count == 12) {
                    phoneNumber = "+" + phoneNumberTextField.text!
                } else if (phoneNumberTextField.text?.count == 13) {
                    phoneNumber = phoneNumberTextField.text!
                } else {
                    alertPhoneNumber(status: "missing")
                }
                self.phoneNumberTextField.isHidden = true
                self.otpTextField.isHidden = false
                infoLabel.text = "Cep Telefonuna gelen 6 haneli kodu girin"
                PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil, completion: {
                    VerificationID, error in if(error != nil)   {
                        return
                    }   else    {
                        self.verification_id = VerificationID
                    }
                })
            }   else    {
                alertPhoneNumber(status: "isEmpty")
            }
        } else    {
            if verification_id != nil   {
                if (!otpTextField.text!.isEmpty)    {
                    Auth.auth().settings?.isAppVerificationDisabledForTesting = false
                    let credential = PhoneAuthProvider.provider().credential(withVerificationID: verification_id!, verificationCode: otpTextField.text!)
                    Auth.auth().signIn(with: credential, completion: {
                        authData, error in
                        if error != nil {
                            print(error.debugDescription)
                        }   else    {
                            UserDefaults.standard.set(self.phoneNumber, forKey: "username")
                            UserDefaults.standard.synchronize()
                            let delegate : AppDelegate = UIApplication.shared.delegate as! AppDelegate
                            self.fcmToken = UserDefaults.standard.string(forKey: "token")!
                            let userInfo = userProfile(phone: self.phoneNumber, token: self.fcmToken!)
                            print(userInfo)
                            do {
                                let jsonData = try JSONEncoder().encode(userInfo)
                                let url = URL(string: "https://amasyaceliklermarket.com/api/phonequery")!
                                var request = URLRequest(url: url)
                                request.httpMethod = "POST"
                                request.httpBody = jsonData
                                print(jsonData)
                                let task = URLSession.shared.dataTask(with: request) { data, response, error in
                                    guard let data = data, error == nil else {
                                        print(error?.localizedDescription ?? "No data")
                                        return
                                    }
                                    do {
                                        let responseJSON = try JSONDecoder().decode([getUserProfile].self, from: data)
                                        let id = responseJSON[0].id
                                        UserDefaults.standard.set(id, forKey: "userID")
                                        UserDefaults.standard.synchronize()
                                    } catch let error   {
                                        print(error)
                                    }
                                }
                                /*---*/
                                task.resume()
                            } catch { print(error) }
                            delegate.rememberUser()
                        }
                    })
                } else {
                    alertPhoneNumber(status: "isOtpEmpty")
                }
            }
        }
    }
    
    @objc func hideKeyboard()   {
        view.endEditing(true)
    }
    
    @objc func keyboardWillShow(sender: NSNotification) {

        if let keyboardRect = (sender.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            self.view.frame.origin.y = -keyboardRect.height
        }
    }
    
    @objc func keyboardWillHide(sender: NSNotification) {
         self.view.frame.origin.y = 0 // Move view to original position
    }
}

struct userProfile : Codable {
    let phone : String
    let token : String
}

struct getUserProfile : Codable {
    let id: String
    let phone: String
    let token: String
}

