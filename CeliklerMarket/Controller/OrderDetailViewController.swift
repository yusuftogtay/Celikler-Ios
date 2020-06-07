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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dateLabel.text = "Tarih: " + date
        timeLabel.text = "Saat: " + time
        deliveryChargeLabel.text = "Gönderim Ücreti: " + deliveryCharge
        if status == "0" {
            cancelOrder.isEnabled = true
        } else {
            cancelOrder.isEnabled = false
        }
        let url = URL(string: "https://amasyaceliklermarket.com/api/order_details")
        ApiService.callPost(url: url!, params: ["sale_id" : sale_id], finish: myOrdersDetailResponse)
        
    }
    
    func myOrdersDetailResponse(message:String, data:Data?) -> Void
    {
        do
        {
            if let JSONString = String(data: data!, encoding: String.Encoding.utf8) {
               print(JSONString)
            }
            if let jsonData = data
            {
                parsedData = try JSONDecoder().decode([myOrderDetails].self, from: jsonData)
                DispatchQueue.main.async {
                    self.orderDetailTable.reloadData()
                }
            }
        }
        catch
        {
            print("Parse Error: \(error)")
        }
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
