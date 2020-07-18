//
//  paymentViewController.swift
//  CeliklerMarket
//
//  Created by Ahmet Yusuf TOĞTAY on 5.06.2020.
//  Copyright © 2020 OzguRND. All rights reserved.
//

import UIKit
import CoreData

class paymentViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return parsedAddressData.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        soCityId = parsedAddressData[indexPath.row].socity_id
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableCell = addressTable.dequeueReusableCell(withIdentifier: "addressCell", for: indexPath)
        let myColor = UIColor.lightGray.cgColor
        tableCell.layer.borderColor = myColor
        tableCell.layer.cornerRadius = 6.0
        tableCell.layer.borderWidth = 1.0
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
            charge.text = "\(parsedAddressData[indexPath.row].delivery_charge)₺"
        }
        return tableCell
    }
    
    var note = String()
    var addressReceiverName = [String?]()
    var addresssocity = [String?]()
    var addressReceiverPhone = [String?]()
    var deliveryCharge = [String?]()
    var soCityId = "0"
    var socityId = [String?]()
    var location_id = [String?]()
    var dayString: String = ""
    var timeString: String = ""
    
    var sendData: [send] = []
    var parsedAddressData: [addressData] = []
    var odeme: String?
    
    let appDelegate = UIApplication.shared.delegate as? AppDelegate


    @IBOutlet weak var day: UIButton!
    @IBOutlet weak var time: UIButton!
    @IBOutlet weak var addressTable: UITableView!
    @IBOutlet weak var addButton: UIButton!
    
    
    @IBAction func nakitSwitch(_ sender: Any) {
        let state = nakit.isOn
        if state    {
            kart.isOn = false
            kendim.isOn = false
            odeme = "Teslimatta Nakit"
        }
    }
    @IBAction func kardSwitch(_ sender: Any) {
        let state = kart.isOn
               if state    {
                   nakit.isOn = false
                kendim.isOn = false
                   odeme = "Teslimatta Banka/Kredi"
               }
    }
    
    @IBAction func kendimmmm(_ sender: Any) {
        let state = kendim.isOn
        if state    {
            nakit.isOn = false
            kart.isOn = false
            odeme = "Kendim Alacağım"
        }
        
    }
    @IBOutlet weak var nakit: UISwitch!
    @IBOutlet weak var kart: UISwitch!
    @IBOutlet weak var kendim: UISwitch!
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        print("Çok ram yiyor")
    }
    
    
    @IBAction func onayla(_ sender: Any) {
        done.isEnabled = false
        let selectedIndexPath = addressTable.indexPathForSelectedRow
        if timeString != "" {
            if selectedIndexPath != nil {
                let index = selectedIndexPath![1]
                let location = parsedAddressData[index].location_id
                var time = timeString.components(separatedBy: ":")
                var lastTime = "\(Int(time[1])! + 30)"
                if lastTime == "60" {
                    lastTime = "00"
                    time[0] = "\(Int(time[0])! + 1)"
                    if time[0] == "24"  {
                        time[0] = "00"
                    }
                }
                let lastttime = "\(time[0]):\(lastTime)"
                let postTime = "\(timeString) - \(lastttime)"
                if note == ""   {
                    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
                    let managedContext = appDelegate.persistentContainer.viewContext
                    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Cards")
                    do {
                        let result = try managedContext.fetch(fetchRequest)
                        for i in result as! [NSManagedObject] {
                            let s = send(product_id: i.value(forKey: "id") as! String,
                                         qty: i.value(forKey: "qty") as! String,
                                         unit_value: i.value(forKey: "unit_value") as! String,
                                         unit: i.value(forKey: "unit") as! String,
                                         price: i.value(forKey: "price") as! String)
                            self.sendData.append(s)
                        }
                        
                    } catch {
                        #if DEBUG
                            print(error)
                        #endif
                    }
                    do  {
                        let data = try JSONEncoder().encode(sendData)
                        let user = UserDefaults.standard.value(forKey: "userID")
                        if let JSONString = String(data: data, encoding: String.Encoding.utf8) {
                           let params: [String: Any] = [
                               "user_id": user!,
                               "date": dayString,
                               "time": postTime,
                               "data": JSONString,
                               "location": location,
                               "payment_method": odeme!,
                           ]
                            let url = URL(string: "https://amasyaceliklermarket.com/api/send_order_ios")
                            if let tabItems = tabBarController?.tabBar.items {
                                let tabItem = tabItems[1]
                                tabItem.badgeValue = "0"
                            }
                            ApiService.callPost(url: url!, params: params, finish: sendOrderResponse)
                        }
                    } catch {
                        #if DEBUG
                            print(error)
                        #endif
                    }
                } else {
                    var data: [sendSpecial] = []
                    data.append(sendSpecial(product_id: "125", qty: "1", unit_value: "1", unit: "ml", price: "1", note: note))
                    do {
                        let data = try JSONEncoder().encode(data)
                        let user = UserDefaults.standard.value(forKey: "userID")
                        if let JSONString = String(data: data, encoding: String.Encoding.utf8) {
                           let params: [String: Any] = [
                               "user_id": user!,
                               "date": dayString,
                               "time": postTime,
                               "data": JSONString,
                               "location": location,
                               "payment_method": odeme!,
                           ]
                            let url = URL(string: "https://amasyaceliklermarket.com/api/send_order_ios")
                            if let tabItems = tabBarController?.tabBar.items {
                                let tabItem = tabItems[1]
                                tabItem.badgeValue = "0"
                            }
                            ApiService.callPost(url: url!, params: params, finish: sendOrderResponse)
                            
                        }
                    } catch  {
                        #if DEBUG
                            print(error)
                        #endif
                    }
                }
            } else {
                let alert = UIAlertController(title: "Bilgilendirme", message: " Teslimat Adresini Seçmediniz", preferredStyle: .alert)
                let action = UIAlertAction(title: "Tamam", style: .default, handler: nil)
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
            }
        } else {
            let alert = UIAlertController(title: "Bilgilendirme", message: "Teslimat zamanını seçmediniz", preferredStyle: .alert)
            let action = UIAlertAction(title: "Tamam", style: .default, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        }
    }
    var noteee = String()

    @IBAction func unWindToBack(_ sender: UIStoryboardSegue) {}
    
    @IBOutlet weak var done: UIButton!
    
    override func viewDidLoad() {
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
        super.viewDidLoad()
        addButton.layer.cornerRadius = 6.0
        day.layer.cornerRadius = 6.0
        done.layer.cornerRadius = 6.0
        time.layer.cornerRadius = 6.0
        odeme = "Teslimatta Nakit"
        kendi.text = "Kendim Alacağım"
        let url = URL(string: "https://amasyaceliklermarket.com/api/get_address")
        let user = UserDefaults.standard.value(forKey: "userID")
        ApiService.callPost(url: url!, params: ["user_id": user!], finish: finishPostAddress)
    }
    
    @IBOutlet weak var kendi: UILabel!
    @IBAction func addAdress(_ sender: Any) {
        performSegue(withIdentifier: "goAddress", sender: nil)
    }
    
    @IBAction func daySend(_ sender: Any) {
        performSegue(withIdentifier: "goDay", sender: nil)
        day.titleLabel?.text = "Teslimat Zamanı:" + "\(dayString)"
    }
    
    @IBAction func timeSend(_ sender: Any) {
        if dayString == ""  {
            DispatchQueue.main.async {
                let alert = UIAlertController(title: "Bilgilendirme", message: "İlk önce Teslimat Gününü Seçin", preferredStyle: .alert)
                let action = UIAlertAction(title: "Tamam", style: .default, handler: nil)
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
            }
            
        } else {
            performSegue(withIdentifier: "goTime", sender: nil)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        day.titleLabel!.text = "Gönderim Günü: \(dayString)"
        time.titleLabel!.text = "Gönderim Saati: \(timeString)"
        let url = URL(string: "https://amasyaceliklermarket.com/api/get_address")
        let user = UserDefaults.standard.value(forKey: "userID")
        ApiService.callPost(url: url!, params: ["user_id": user!], finish: finishPostAddress)
        day.titleLabel?.text = "Teslimat Zamanı:" + "\(dayString)"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goTime" {
            let destination = segue.destination as! timeViewController
            destination.day = dayString
        }
    }
    
    private func sendOrderResponse(message:String, data:Data?) -> Void
    {
        do
        {
            if let jsonData = data
            {
                let parsedData = try JSONDecoder().decode(sendOrder.self, from: jsonData)
                if parsedData.response == true {
                    let managedContext = appDelegate!.persistentContainer.viewContext
                    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Cards")
                    if let result = try? managedContext.fetch(fetchRequest) {
                        for object in result {
                            managedContext.delete(object as! NSManagedObject)
                        }
                        do{
                            try managedContext.save()
                        }
                        catch
                        {
                            #if DEBUG
                            print(error)
                            #endif
                        }
                    }
                }
                alerrt(message: parsedData.data)
            }
        }
        catch
        {
            #if DEBUG
                print(error)
            #endif
        }
    }
    
    private func alerrt(message: String, title: String = "") {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Siparişniz Başarıyla Alınmıştır", message: message, preferredStyle: .alert)
            let action = UIAlertAction(title: "Tamam", style: .default, handler: { (action: UIAlertAction!) in
                if let firstViewController = self.navigationController?.viewControllers.first {
                    self.navigationController?.popToViewController(firstViewController, animated: true)
                }
            })
            alert.addAction(action)
            self.addButton.isEnabled = true
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    private func finishPostAddress (message:String, data:Data?) -> Void
    {
        do
        {
            if let jsonData = data
            {
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
            #if DEBUG
                print(error)
            #endif
        }
    }
}
