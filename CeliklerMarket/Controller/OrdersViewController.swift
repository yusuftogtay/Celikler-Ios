//
//  ordersViewController.swift
//  CeliklerMarket
//
//  Created by Ahmet Yusuf TOĞTAY on 31.05.2020.
//  Copyright © 2020 OzguRND. All rights reserved.
//

import UIKit


class ordersViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var ordersCollectionView: UICollectionView!
    
    var parsedData: [myOrders] = []
    var sale_id: String = ""
    var status: String = ""
    var date: String = ""
    var time: String = ""
    var deliveryCharge = ""
    let imageb = UIImage(named: "b")
    let imaged = UIImage(named: "d")
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        print("Çok ram yiyor")
    }
    
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        parsedData.removeAll()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        let user : String? =  UserDefaults.standard.string(forKey: "username")
        if user != nil  {
            swgment.isHidden = false
            ordersCollectionView.isHidden = false
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
        } else {
            swgment.isHidden = true
            ordersCollectionView.isHidden = true
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
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return parsedData.count
    }
    
    func myOrdersResponse(message:String, data:Data?) -> Void
    {
        do
        {
            parsedData.removeAll()
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
            #if DEBUG
                print(error)
            #endif
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
            let fiyat = Double(parsedData[indexPath.row].total_amount)!
            let t = Double(fiyat)
            deliveryTime.text =  String(format: "%.2f₺", t)
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
            if parsedData[indexPath.row].status == "3"  {
                status.text = "İptal Edildi"
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
                    deliveryTime.image = imaged
                }
            }
            if parsedData[indexPath.row].status == "1"  {
                if #available(iOS 13.0, *) {
                    deliveryTime.image = UIImage(systemName: "circle.fill")
                } else {
                    deliveryTime.image = imaged
                }
            }
            if parsedData[indexPath.row].status == "2"  {
                if #available(iOS 13.0, *) {
                    deliveryTime.image = UIImage(systemName: "circle.fill")
                } else {
                    deliveryTime.image = imaged
                }
            }
            if parsedData[indexPath.row].status == "4"  {
                if #available(iOS 13.0, *) {
                    deliveryTime.image = UIImage(systemName: "circle.fill")
                } else {
                    deliveryTime.image = imaged
                }
            }
            if parsedData[indexPath.row].status == "4"  {
                if #available(iOS 13.0, *) {
                    deliveryTime.image = UIImage(systemName: "circle.fill")
                } else {
                    deliveryTime.image = imaged
                }
            }
        }
        if let deliveryTime = cell.viewWithTag(91) as? UIImageView    {
            if parsedData[indexPath.row].status == "0"  {
                if #available(iOS 13.0, *) {
                    deliveryTime.image = UIImage(systemName: "circle")
                } else {
                    deliveryTime.image = imageb
                }
            }
            if parsedData[indexPath.row].status == "1"  {
                if #available(iOS 13.0, *) {
                    deliveryTime.image = UIImage(systemName: "circle.fill")
                } else {
                    deliveryTime.image = imaged
                }
            }
            if parsedData[indexPath.row].status == "2"  {
                if #available(iOS 13.0, *) {
                    deliveryTime.image = UIImage(systemName: "circle.fill")
                } else {
                    deliveryTime.image = imaged
                }
            }
            if parsedData[indexPath.row].status == "4"  {
                if #available(iOS 13.0, *) {
                    deliveryTime.image = UIImage(systemName: "circle.fill")
                } else {
                    deliveryTime.image = imaged
                }
            }
            if parsedData[indexPath.row].status == "4"  {
                if #available(iOS 13.0, *) {
                    deliveryTime.image = UIImage(systemName: "circle.fill")
                } else {
                    deliveryTime.image = imaged
                }
            }
        }
        if let deliveryTime = cell.viewWithTag(92) as? UIImageView    {
            if parsedData[indexPath.row].status == "0"  {
                if #available(iOS 13.0, *) {
                    deliveryTime.image = UIImage(systemName: "circle")
                } else {
                    deliveryTime.image = imageb
                }
            }
            if parsedData[indexPath.row].status == "1"  {
                if #available(iOS 13.0, *) {
                    deliveryTime.image = UIImage(systemName: "circle")
                } else {
                    deliveryTime.image = imageb
                }
            }
            if parsedData[indexPath.row].status == "2"  {
                if #available(iOS 13.0, *) {
                    deliveryTime.image = UIImage(systemName: "circle.fill")
                } else {
                    deliveryTime.image = imaged
                }
            }
            if parsedData[indexPath.row].status == "4"  {
                if #available(iOS 13.0, *) {
                    deliveryTime.image = UIImage(systemName: "circle.fill")
                } else {
                    deliveryTime.image = imaged
                }
            }
            if parsedData[indexPath.row].status == "4"  {
                if #available(iOS 13.0, *) {
                    deliveryTime.image = UIImage(systemName: "circle.fill")
                } else {
                    deliveryTime.image = imaged
                }
            }
        }
        if let deliveryTime = cell.viewWithTag(93) as? UIImageView    {
            if parsedData[indexPath.row].status == "0"  {
                if #available(iOS 13.0, *) {
                    deliveryTime.image = UIImage(systemName: "circle")
                } else {
                    deliveryTime.image = imageb
                }
            }
            if parsedData[indexPath.row].status == "1"  {
                if #available(iOS 13.0, *) {
                    deliveryTime.image = UIImage(systemName: "circle")
                } else {
                    deliveryTime.image = imageb
                }
            }
            if parsedData[indexPath.row].status == "2"  {
                if #available(iOS 13.0, *) {
                    deliveryTime.image = UIImage(systemName: "circle")
                } else {
                    deliveryTime.image = imageb
                }
            }
            if parsedData[indexPath.row].status == "4"  {
                if #available(iOS 13.0, *) {
                    deliveryTime.image = UIImage(systemName: "circle.fill")
                } else {
                    deliveryTime.image = imaged
                }
            }
            if parsedData[indexPath.row].status == "4"  {
                if #available(iOS 13.0, *) {
                    deliveryTime.image = UIImage(systemName: "circle.fill")
                } else {
                    deliveryTime.image = imaged
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
        let screenWidth = ordersCollectionView.frame.width
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



