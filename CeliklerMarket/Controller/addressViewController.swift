//
//  addressViewController.swift
//  CeliklerMarket
//
//  Created by Ahmet Yusuf TOĞTAY on 6.06.2020.
//  Copyright © 2020 OzguRND. All rights reserved.
//

import UIKit

class addressViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var parsedAddressData: [addressData] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        let url = URL(string: "https://amasyaceliklermarket.com/api/get_address")
        let user = UserDefaults.standard.value(forKey: "userID")
        ApiService.callPost(url: url!, params: ["user_id": user!], finish: finishPostAddress)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        let url = URL(string: "https://amasyaceliklermarket.com/api/get_address")
        let user = UserDefaults.standard.value(forKey: "userID")
        ApiService.callPost(url: url!, params: ["user_id": user!], finish: finishPostAddress)
        
    }
    
    @IBOutlet weak var addressTable: UITableView!
    
    func finishPostAddress (message:String, data:Data?) -> Void
    {
        do
        {
            if let jsonData = data
            {
                if let JSONString = String(data: jsonData, encoding: String.Encoding.utf8) {
                   print(JSONString)
                }
                let  parseData = try JSONDecoder().decode(address.self, from: jsonData)
                if parseData.response == true   {
                    parsedAddressData = parseData.data
                    DispatchQueue.main.sync {
                        self.addressTable.reloadData()
                    }
                }
            }
        }
        catch
        {
            print("Parse Error: \(error)")
        }
    }
    
    func finishDeleteAddress (message:String, data:Data?) -> Void
    {
        do
        {
            if let jsonData = data
            {
                if let JSONString = String(data: jsonData, encoding: String.Encoding.utf8) {
                   print(JSONString)
                }
                let  parseData = try JSONDecoder().decode(deleteAddress.self, from: jsonData)
                if parseData.response == true   {
                    let alert = UIAlertController(title: "İşlem Başarılı", message: parseData.message, preferredStyle: .alert)

                    let action = UIAlertAction(title: "Tamam", style: .default, handler: nil)
                    alert.addAction(action)
                    
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
        catch
        {
            print("Parse Error: \(error)")
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableCell = addressTable.dequeueReusableCell(withIdentifier: "addressCell", for: indexPath)
        if let name = tableCell.viewWithTag(10) as? UILabel    {
            name.text = parsedAddressData[indexPath.row].receiver_name
        }
        if let phone = tableCell.viewWithTag(12) as? UILabel    {
            phone.text = parsedAddressData[indexPath.row].receiver_mobile
        }
        if let socity = tableCell.viewWithTag(11) as? UILabel    {
            socity.text = parsedAddressData[indexPath.row].socity_name
        }
        if let charge = tableCell.viewWithTag(13) as? UILabel    {
            charge.text = parsedAddressData[indexPath.row].delivery_charge
        }
        return tableCell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return parsedAddressData.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //soCityId = parsedAddressData[indexPath.row].socity_id
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete  {
            let url = URL(string: "https://amasyaceliklermarket.com/api/delete_address")
            let locationID = parsedAddressData[indexPath.row].location_id
            ApiService.callPost(url: url!, params: ["location_id": locationID], finish: finishPostAddress)
            parsedAddressData.remove(at: indexPath.row)
            addressTable.deleteRows(at: [indexPath], with: .left)
        }
    }
}
