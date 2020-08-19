//
//  OrderDetailViewController.swift
//  CeliklerMarket
//
//  Created by Ahmet Yusuf TOĞTAY on 6.06.2020.
//  Copyright © 2020 OzguRND. All rights reserved.
//

import UIKit
import SDWebImage

class OrderDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var date: String = ""
    var time: String = ""
    var deliveryCharge = ""
    var status: String = ""
    let placeHolderImage = UIImage(named: "V1")
    var sale_id: String = ""
    var parsedData: [myOrderDetails] = []
    @IBOutlet weak var orderDetailTable: UITableView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var deliveryChargeLabel: UILabel!
    @IBOutlet weak var cancelOrder: UIButton!
    @IBOutlet weak var totalLabel: UILabel!
    
    override func viewDidLoad() {
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        super.viewDidLoad()
        dateLabel.text = "Tarih: " + date
        timeLabel.text = "Saat: " + time
        deliveryChargeLabel.text = "Gönderim Ücreti: " + deliveryCharge
        cancelOrder.layer.cornerRadius = 6.0
        if status == "0" {
            cancelOrder.isEnabled = true
        } else {
            cancelOrder.isEnabled = false
        }
        let url = URL(string: "https://amasyaceliklermarket.com/api/order_details")
        ApiService.callPost(url: url!, params: ["sale_id" : sale_id], finish: myOrdersDetailResponse)
        
    }
    @IBAction func cancelOrder(_ sender: Any) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Onay", message: "Siparişinizi iptal etmek istiyor musunuz", preferredStyle: .alert)

            let okAction = UIAlertAction(title: "Evet", style: UIAlertAction.Style.default) {
                UIAlertAction in
                let url = URL(string: "https://amasyaceliklermarket.com/api/cancel_order")
                let user = UserDefaults.standard.value(forKey: "userID")
                ApiService.callPost(url: url!, params: ["sale_id" : self.sale_id, "user_id" : user!], finish: self.myOrdersCancelResponse)
            }
            let cancelAction = UIAlertAction(title: "Hayır", style: UIAlertAction.Style.cancel) {
                UIAlertAction in
                
            }
            alert.addAction(okAction)
               alert.addAction(cancelAction)
            
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
    private func myOrdersCancelResponse(message:String, data:Data?) -> Void
    {
        do
        {
            if let jsonData = data
            {
                let response = try JSONDecoder().decode(cancelOrders.self, from: jsonData)
                if response.response == true    {
                    DispatchQueue.main.async {
                        let alert = UIAlertController(title: "", message: response.message, preferredStyle: .alert)
                        
                        let okAction = UIAlertAction(title: "Tamam", style: UIAlertAction.Style.default) {
                            UIAlertAction in
                            if let firstViewController = self.navigationController?.viewControllers.first {
                                self.navigationController?.popToViewController(firstViewController, animated: true)
                            }
                        }
                        alert.addAction(okAction)
                        self.present(alert, animated: true, completion: nil)
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
    
    private func myOrdersDetailResponse(message:String, data:Data?) -> Void
    {
        do
        {
            if let JSONString = String(data: data!, encoding: String.Encoding.utf8) {
               print(JSONString)
            }
            if let jsonData = data
            {
                parsedData = try JSONDecoder().decode([myOrderDetails].self, from: jsonData)
                total()
                DispatchQueue.main.async {
                    self.orderDetailTable.reloadData()
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
    
    private func total() {
        var total: Double = 0
        for i in parsedData {
            let price = Double(i.price)!
            let qty = Double(i.qty)!
            total += Double(price * qty)
        }
        DispatchQueue.main.async {
            let t = (Double(total) + Double(self.deliveryCharge)!)
            //self.totalLabel.text = "Toplam: \(t.format(".2"))"
            self.totalLabel.text = String(format: "Toplam: %.2f", t)
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return parsedData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableCell = orderDetailTable.dequeueReusableCell(withIdentifier: "detail", for: indexPath)
        tableCell.layer.cornerRadius = 6.0
        tableCell.layer.borderWidth = 0.5
        if let productName = tableCell.viewWithTag(600) as? UILabel {
            productName.text = parsedData[indexPath.row].product_name
        }
        if let productName = tableCell.viewWithTag(502) as? UILabel {
            productName.text = "Fiyatı: " + String(parsedData[indexPath.row].price) + "₺"
        }
        if let productName = tableCell.viewWithTag(504) as? UILabel {
            productName.text = "Adeti: " + String(parsedData[indexPath.row].qty)
        }
        
        let imageUrl = URL(string: "https://amasyaceliklermarket.com" + String(parsedData[indexPath.row].product_image))
        if let productImage = tableCell.viewWithTag(501) as? UIImageView {
            productImage.sd_setImage(with: imageUrl, placeholderImage: placeHolderImage, options: SDWebImageOptions.highPriority, context: nil)
        }
        return (tableCell)
    }
}
