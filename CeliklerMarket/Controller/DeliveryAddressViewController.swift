//
//  deliveryAddressViewController.swift
//  CeliklerMarket
//
//  Created by Ahmet Yusuf TOĞTAY on 29.05.2020.
//  Copyright © 2020 OzguRND. All rights reserved.
//

import UIKit

class deliveryAddressViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    
    var socityAddress = [String?]()
    var socityId = [String?]()
    var soCityIdset = "0"
    var data = [String: Any]()
    
    
    override func viewDidLoad() {
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        super.viewDidLoad()
        
        socityCollection.delegate = self
        socityCollection.dataSource = self
        addressModel()
    }
    @IBOutlet weak var nameLabel: UITextField!
    @IBOutlet weak var phoneLabel: UITextField!
    @IBOutlet weak var socityCollection: UITableView!
    @IBOutlet weak var addressLabel: UITextField!
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        self.nameLabel.delegate = self
        self.phoneLabel.delegate = self
        self.addressLabel.delegate = self
        return false
    }
    
    func addressModel()
    {
       if let url = URL(string: "https://amasyaceliklermarket.com/api/get_society") {
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data {
                   do {
                    let res = try JSONDecoder().decode([socity].self, from: data)
                    for r in res   {
                        DispatchQueue.main.async {
                            self.socityAddress.append(r.socity_name)
                            self.socityId.append(r.socity_id)
                            self.socityCollection.reloadData()
                        }
                    }
                   } catch let error {
                      print(error)
                   }
                }
            }.resume()
        }
    }
    @IBAction func addAdress(_ sender: Any) {
        if (nameLabel.text?.isEmpty == true || ((phoneLabel.text?.isEmpty) == true) || ((addressLabel.text?.isEmpty) == true) || soCityIdset == "0")   {
            let alert = UIAlertController(title: "Hata!", message: "Eksik Bilgi Bulunmaktadır", preferredStyle: .alert)

            let action = UIAlertAction(title: "Tamam", style: .default, handler: nil)
            alert.addAction(action)
            
            self.present(alert, animated: true, completion: nil)
        }   else    {
            let user = UserDefaults.standard.value(forKey: "userID")
            let params: [String: Any] = [
                "user_id": user!,
                "t_adress": "Nugbfgll",
                "socity_id": soCityIdset as Any,
                "adress": addressLabel.text!,
                "receiver_name": nameLabel.text!,
                "receiver_mobile": nameLabel.text!,
            ]
            print(params as [String: Any])
            let url = URL(string: "https://amasyaceliklermarket.com/api/ekle_adres")
            ApiService.callPost(url: url!, params: params, finish: addressResponse)
        }
    }
    
    func addressResponse(message:String, data:Data?) -> Void
    {
        do
        {
            if let jsonData = data
            {
                let parsedData = try JSONDecoder().decode(getAddress.self, from: jsonData)
                if parsedData.response == true{
                    let alert = UIAlertController(title: "", message: "Adress Başarıyla Eklenmiştir", preferredStyle: .alert)

                    let action = UIAlertAction(title: "Tamam", style: .default, handler: { (action: UIAlertAction!) in
                        //self.performSegue(withIdentifier: "goBackDelivery", sender: nil)
                        //self.navigationController?.popToRootViewController(animated: true)
                    })
                    alert.addAction(action)
                    DispatchQueue.main.async {
                        self.present(alert, animated: true, completion: nil)
                    }
                }
            }
        }
        catch
        {
            print("Parse Error: \(error)")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let backItem = UIBarButtonItem()
        backItem.title = "Geri"
        navigationItem.backBarButtonItem = backItem // This will show in the next view controller being pushed
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return socityAddress.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableCell = socityCollection.dequeueReusableCell(withIdentifier: "socityCell", for: indexPath)
        let myColor = UIColor.lightGray.cgColor
        tableCell.layer.borderColor = myColor
        tableCell.layer.cornerRadius = 6.0
        tableCell.layer.borderWidth = 0.5
        if let vcTitle = tableCell.viewWithTag(4) as? UILabel    {
            vcTitle.text = socityAddress[indexPath.row]
        }
        return tableCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        soCityIdset = socityId[indexPath.row]!
        print(soCityIdset)
    }
}
