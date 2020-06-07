//
//  ordersViewController.swift
//  CeliklerMarket
//
//  Created by Ahmet Yusuf TOĞTAY on 31.05.2020.
//  Copyright © 2020 OzguRND. All rights reserved.
//

import UIKit


class ordersViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource  {
    
    @IBOutlet weak var ordersCollectionView: UICollectionView!
    
    var parsedData: [myOrders] = []
    var sale_id: String = ""
    var status: String = ""
    var date: String = ""
    var time: String = ""
    var deliveryCharge = ""
    
    @IBAction func segmentControl(_ sender: Any) {
        switch swgment.selectedSegmentIndex {
        case 0:
            let user = UserDefaults.standard.value(forKey: "userID")
            let url = URL(string: "https://amasyaceliklermarket.com/api/my_orders")
            ApiService.callPost(url: url!, params: ["user_id" : user!], finish: myOrdersResponse)
        case 1:
            let user = UserDefaults.standard.value(forKey: "userID")
            let url = URL(string: "https://amasyaceliklermarket.com/api/my_old_orders")
            ApiService.callPost(url: url!, params: ["user_id" : user!], finish: myOrdersResponse)
        default:
            print("0")
        }
    }
    
    @IBAction func cellTapped(deneme: Int)   {
        sale_id = parsedData[deneme].sale_id
        status = parsedData[deneme].status
        date = parsedData[deneme].on_date
        deliveryCharge = parsedData[deneme].delivery_charge
        time = parsedData[deneme].delivery_time_from + " - " + parsedData[deneme].delivery_time_to
        performSegue(withIdentifier: "goDetail", sender: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goDetail" {
            let destination = segue.destination as! OrderDetailViewController
            destination.sale_id = sale_id
            destination.status = status
            destination.date = date
            destination.time = time
            destination.deliveryCharge = deliveryCharge
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        cellTapped(deneme: indexPath.row)
    }
    
    @IBOutlet weak var swgment: UISegmentedControl!
    
    
    override func viewDidLoad() {
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
        }
        super.viewDidLoad()
        let nib = UINib(nibName: "ordersCell", bundle:nil)
        self.ordersCollectionView.register(nib, forCellWithReuseIdentifier: "CollectionViewCell")
        ordersCollectionView.delegate = self
        ordersCollectionView.dataSource = self
        
        let user = UserDefaults.standard.value(forKey: "userID")
        let url = URL(string: "https://amasyaceliklermarket.com/api/my_orders")
        ApiService.callPost(url: url!, params: ["user_id" : user!], finish: myOrdersResponse)
        }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return parsedData.count
    }
    
    func myOrdersResponse(message:String, data:Data?) -> Void
    {
        do
        {
            if let JSONString = String(data: data!, encoding: String.Encoding.utf8) {
               print(JSONString)
            }
            if let jsonData = data
            {
                parsedData = try JSONDecoder().decode([myOrders].self, from: jsonData)
                DispatchQueue.main.async {
                    self.ordersCollectionView.reloadData()
                }
            }
        }
        catch
        {
            print("Parse Error: \(error)")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ordersCell", for: indexPath)
        cell.layer.cornerRadius = 6.0
        cell.layer.borderWidth = 0.5
        let myColor = UIColor.lightGray.cgColor
        cell.layer.borderColor = myColor
        if let id = cell.viewWithTag(89) as? UIStackView    {
            id.addBackground(color: UIColor.lightGray)
        }
        if let id = cell.viewWithTag(70) as? UILabel    {
            id.text = parsedData[indexPath.row].sale_id
        }
        if let date = cell.viewWithTag(71) as? UILabel    {
            date.text = parsedData[indexPath.row].on_date
        }
        if let unit = cell.viewWithTag(72) as? UILabel    {
            unit.text = parsedData[indexPath.row].total_items
        }
        if let paymentMethod = cell.viewWithTag(88) as? UILabel    {
            paymentMethod.text = parsedData[indexPath.row].payment_method
        }
        if let deliveryTime = cell.viewWithTag(73) as? UILabel    {
            deliveryTime.text = parsedData[indexPath.row].total_amount + "₺"
        }
        if let status = cell.viewWithTag(74) as? UILabel    {
            if parsedData[indexPath.row].status == "0"  {
                status.text = "Aktif"
            }
            if parsedData[indexPath.row].status == "1"  {
                status.text = "Aktif"
            }
            if parsedData[indexPath.row].status == "2"  {
                status.text = "Aktif"
            }
            if parsedData[indexPath.row].status == "4"  {
                status.text = "Aktif"
            }
            if parsedData[indexPath.row].status == "4"  {
               status.text = "Aktif"
            }
        }
        if let deliveryTime = cell.viewWithTag(90) as? UIImageView    {
            if parsedData[indexPath.row].status == "0"  {
                if #available(iOS 13.0, *) {
                    deliveryTime.image = UIImage(systemName: "circle.fill")
                } else {
                    // Fallback on earlier versions
                }
            }
            if parsedData[indexPath.row].status == "1"  {
                if #available(iOS 13.0, *) {
                    deliveryTime.image = UIImage(systemName: "circle.fill")
                } else {
                    // Fallback on earlier versions
                }
            }
            if parsedData[indexPath.row].status == "2"  {
                if #available(iOS 13.0, *) {
                    deliveryTime.image = UIImage(systemName: "circle.fill")
                } else {
                    // Fallback on earlier versions
                }
            }
            if parsedData[indexPath.row].status == "4"  {
                if #available(iOS 13.0, *) {
                    deliveryTime.image = UIImage(systemName: "circle.fill")
                } else {
                    // Fallback on earlier versions
                }
            }
            if parsedData[indexPath.row].status == "4"  {
                if #available(iOS 13.0, *) {
                    deliveryTime.image = UIImage(systemName: "circle.fill")
                } else {
                    // Fallback on earlier versions
                }
            }
        }
        if let deliveryTime = cell.viewWithTag(91) as? UIImageView    {
            if parsedData[indexPath.row].status == "0"  {
                if #available(iOS 13.0, *) {
                    deliveryTime.image = UIImage(systemName: "circle")
                } else {
                    // Fallback on earlier versions
                }
            }
            if parsedData[indexPath.row].status == "1"  {
                if #available(iOS 13.0, *) {
                    deliveryTime.image = UIImage(systemName: "circle.fill")
                } else {
                    // Fallback on earlier versions
                }
            }
            if parsedData[indexPath.row].status == "2"  {
                if #available(iOS 13.0, *) {
                    deliveryTime.image = UIImage(systemName: "circle.fill")
                } else {
                    // Fallback on earlier versions
                }
            }
            if parsedData[indexPath.row].status == "4"  {
                if #available(iOS 13.0, *) {
                    deliveryTime.image = UIImage(systemName: "circle.fill")
                } else {
                    // Fallback on earlier versions
                }
            }
            if parsedData[indexPath.row].status == "4"  {
                if #available(iOS 13.0, *) {
                    deliveryTime.image = UIImage(systemName: "circle.fill")
                } else {
                    // Fallback on earlier versions
                }
            }
        }
        if let deliveryTime = cell.viewWithTag(92) as? UIImageView    {
            if parsedData[indexPath.row].status == "0"  {
                if #available(iOS 13.0, *) {
                    deliveryTime.image = UIImage(systemName: "circle")
                } else {
                    // Fallback on earlier versions
                }
            }
            if parsedData[indexPath.row].status == "1"  {
                if #available(iOS 13.0, *) {
                    deliveryTime.image = UIImage(systemName: "circle")
                } else {
                    // Fallback on earlier versions
                }
            }
            if parsedData[indexPath.row].status == "2"  {
                if #available(iOS 13.0, *) {
                    deliveryTime.image = UIImage(systemName: "circle.fill")
                } else {
                    // Fallback on earlier versions
                }
            }
            if parsedData[indexPath.row].status == "4"  {
                if #available(iOS 13.0, *) {
                    deliveryTime.image = UIImage(systemName: "circle.fill")
                } else {
                    // Fallback on earlier versions
                }
            }
            if parsedData[indexPath.row].status == "4"  {
                if #available(iOS 13.0, *) {
                    deliveryTime.image = UIImage(systemName: "circle.fill")
                } else {
                    // Fallback on earlier versions
                }
            }
        }
        if let deliveryTime = cell.viewWithTag(93) as? UIImageView    {
            if parsedData[indexPath.row].status == "0"  {
                if #available(iOS 13.0, *) {
                    deliveryTime.image = UIImage(systemName: "circle")
                } else {
                    // Fallback on earlier versions
                }
            }
            if parsedData[indexPath.row].status == "1"  {
                if #available(iOS 13.0, *) {
                    deliveryTime.image = UIImage(systemName: "circle")
                } else {
                    // Fallback on earlier versions
                }
            }
            if parsedData[indexPath.row].status == "2"  {
                if #available(iOS 13.0, *) {
                    deliveryTime.image = UIImage(systemName: "circle")
                } else {
                    // Fallback on earlier versions
                }
            }
            if parsedData[indexPath.row].status == "4"  {
                if #available(iOS 13.0, *) {
                    deliveryTime.image = UIImage(systemName: "circle.fill")
                } else {
                    // Fallback on earlier versions
                }
            }
            if parsedData[indexPath.row].status == "4"  {
                if #available(iOS 13.0, *) {
                    deliveryTime.image = UIImage(systemName: "circle.fill")
                } else {
                    // Fallback on earlier versions
                }
            }
        }
        if let paymnetMethod = cell.viewWithTag(75) as? UILabel    {
            paymnetMethod.text = parsedData[indexPath.row].payment_method
        }
        if let time = cell.viewWithTag(76) as? UILabel    {
            time.text = "\(parsedData[indexPath.row].delivery_time_from) - \(parsedData[indexPath.row].delivery_time_to) "
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenWidth = UIScreen.main.bounds.width
           let height = ordersCollectionView.frame.height / 4
           return CGSize(width: screenWidth, height: height)
    }
}

extension UIStackView {
    func addBackground(color: UIColor) {
        let subView = UIView(frame: bounds)
        subView.backgroundColor = color
        subView.alpha = 0.4
        subView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        insertSubview(subView, at: 0)
    }
}



