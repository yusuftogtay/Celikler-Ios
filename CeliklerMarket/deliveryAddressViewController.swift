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
    var soCityId = "0"
    var data = [String: Any]()
    
    
    override func viewDidLoad() {
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
        if (nameLabel.text?.isEmpty == true || ((phoneLabel.text?.isEmpty) == true) || ((addressLabel.text?.isEmpty) == true) || soCityId == "0")   {
            let alert = UIAlertController(title: "Hata!", message: "Eksik Bilgi Bulunmaktadır", preferredStyle: .alert)

            let action = UIAlertAction(title: "Tamam", style: .default, handler: nil)
            alert.addAction(action)
            
            self.present(alert, animated: true, completion: nil)
        }   else    {
            let user = UserDefaults.standard.value(forKey: "userID")
            let params: [String: Any] = [
                "user_id": user!,
                "t_adress": "Nugbfgll",
                "socity_id": soCityId as Any,
                "adress": addressLabel.text!,
                "receiver_name": nameLabel.text!,
                "receiver_mobile": nameLabel.text!,
            ]
            print(params as [String: Any])
            let url = URL(string: "https://amasyaceliklermarket.com/api/ekle_adres")
            AddressApiService.callPost(url: url!, params: params, finish: addressResponse)
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
    
    struct socity: Codable {
        let socity_id, socity_name, delivery_charge, delivery_time: String
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return socityAddress.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableCell = socityCollection.dequeueReusableCell(withIdentifier: "socityCell", for: indexPath)
        if let vcTitle = tableCell.viewWithTag(4) as? UILabel    {
            vcTitle.text = socityAddress[indexPath.row]
        }
        return tableCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        soCityId = socityId[indexPath.row]!
        print(socityId)
    }
}

class AddressApiService   {
    static func getPostString(params:[String: Any]) -> String
    {
        var data = [String]()
            for (key, value) in params
            {
                data.append(key + "=\(value)")
            }
        return data.map { String($0) }.joined(separator: "&")
    }

    static func callPost(url:URL, params:[String: Any], finish: @escaping ((message:String, data:Data?)) -> Void)
    {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        let postString = self.getPostString(params: params)
        request.httpBody = postString.data(using: .utf8)

        var result:(message:String, data:Data?) = (message: "Fail", data: nil)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in

            if(error != nil)
            {
                result.message = "Fail Error not null : \(error.debugDescription)"
            }
            else
            {
                result.message = "Success"
                result.data = data
            }

            finish(result)
        }
        task.resume()
    }
}
