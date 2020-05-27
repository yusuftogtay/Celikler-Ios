//
//  ShoppingCardViewController.swift
//  CeliklerMarket
//
//  Created by Ahmet Yusuf TOĞTAY on 26.05.2020.
//  Copyright © 2020 OzguRND. All rights reserved.
//

import UIKit

class ShoppingCardViewController: UIViewController,  UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var cardID = [String?]()
    var cardName = [String?]()
    var cardDescription = [String?]()
    var cardImage = [UIImage?]()
    var cardCategoryID = [String?]()
    var cardInStock = [String?]()
    var cardPrice = [String?]()
    var cardUnitValue = [String?]()
    var cardUnit = [String?]()
    
    var addressReceiverName = [String?]()
    var addresssocity = [String?]()
    var addressReceiverPhone = [String?]()
    var deliveryCharge = [String?]()
    
    var date: Date?
    var time: Date?
    
    @IBOutlet weak var navbar: UINavigationBar!
    @IBOutlet weak var cardClear: UIButton!
    @IBOutlet weak var cardsView: UICollectionView!
    @IBOutlet weak var productUnit: UILabel!
    @IBOutlet weak var total: UILabel!
    @IBOutlet weak var pay: UIButton!
    @IBOutlet weak var bagImage: UIImageView!
    @IBOutlet weak var cardEmptyInfo: UILabel!
    @IBOutlet weak var MainPageSegueButton: UIButton!
    @IBOutlet weak var sendDay: UIButton!
    @IBOutlet weak var sendtime: UIButton!
    @IBOutlet weak var sendDayPicker: UIDatePicker!
    @IBOutlet weak var sendTimePicker: UIDatePicker!
    @IBOutlet weak var selectDay: UIButton!
    @IBOutlet weak var addAdress: UIButton!
    @IBOutlet weak var addressCollection: UICollectionView!
    @IBOutlet weak var pay2: UIButton!
    @IBOutlet weak var tutar2: UILabel!
    @IBOutlet weak var adet2: UILabel!
    @IBOutlet weak var selectTime: UIButton!
    @IBOutlet weak var addressStack: UIStackView!
    
    
    @IBAction func selectTime(_ sender: Any) {
        self.sendTimePicker.isHidden = true
        self.selectTime.isHidden = true
        sendDay.isHidden = false
        sendtime.isHidden = false
        self.addressStack.isHidden = false
    }
    
    override func viewDidLoad() {
        addAdress.isHidden = true
        addressCollection.isHidden = true
        pay2.isHidden = true
        tutar2.isHidden = true
        adet2.isHidden = true
        MainPageSegueButton.isHidden = true
        bagImage.isHidden = true
        super.viewDidLoad()
        //Date
        sendDayPicker.minimumDate = Date()
        //TO:DO max date
        sendDayPicker.date = Date()
        sendDayPicker.datePickerMode = .date
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(doSomething), for: .valueChanged)

        // this is the replacement of implementing: "collectionView.addSubview(refreshControl)"
        cardsView.refreshControl = refreshControl
        
        //UIHidden
        addressStack.isHidden = true
        sendTimePicker.isHidden = true
        sendDayPicker.isHidden = true
        selectDay.isHidden = true
        selectTime.isHidden = true
        sendDay.isHidden = true
        sendtime.isHidden = true
        cardCell()
    }
    
    @IBAction func addAddress(_ sender: Any) {
        let userId = UserDefaults.standard.value(forKey: "userID")
        let url = URL(string: "https://amasyaceliklermarket.com/api/ekle_adres")
        ApiService.callPost(url: url!, params: ["user_id": userId], finish: finishPostAdress)
    }
    
    @objc func doSomething(refreshControl: UIRefreshControl) {
        cardCell()
        refreshControl.endRefreshing()
    }
    
    @IBAction func sendDay(_ sender: Any) {
        self.addressStack.isHidden = true
        deliveryInformationHide()
        sendDayPicker.isHidden = false
        selectDay.isHidden = false
    }
    
    @IBAction func selectDay(_ sender: Any) {
        self.addressStack.isHidden = false
        date = sendDayPicker.date
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-dd"
        let dayString = formatter.string(from: date!)
        postTimeSlot(date: dayString)
        sendDayPicker.isHidden = true
        selectDay.isHidden = true
        sendDay.isHidden = false
        sendtime.isHidden = false
    }
    
    @IBAction func sendTime(_ sender: Any) {
        self.addressStack.isHidden = true
        sendDay.isHidden = true
        sendtime.isHidden = true
        self.sendTimePicker.isHidden = false
        self.selectTime.isHidden = false
    }
    
    func isEmptyCard() {
        cardClear.isHidden = true
        cardsView.isHidden = true
        productUnit.isHidden = true
        total.isHidden = true
        pay.isHidden = true
    }
    
    func notEmptyCard() {
        bagImage.isHidden = true
        cardEmptyInfo.isHidden = true
        MainPageSegueButton.isHidden = true
    }
    
    func deliveryInformationHide()  {
        sendDay.isHidden = true
        sendtime.isHidden = true
    }
    
    @IBAction func cardClear(_ sender: Any) {
        UserDefaults.standard.removeObject(forKey: "cards")
        UserDefaults.standard.synchronize()
        DispatchQueue.main.async{
            self.cardID.removeAll()
            self.cardName.removeAll()
            self.cardPrice.removeAll()
            self.cardCategoryID.removeAll()
            self.cardUnitValue.removeAll()
            self.cardUnit.removeAll()
            self.cardImage.removeAll()
            self.cardsView.reloadData()
        }
        isEmptyCard()
        bagImage.isHidden = false
        cardEmptyInfo.isHidden = false
    }
    
    @IBAction func pay(_ sender: Any) {
        isEmptyCard()
        sendDay.isHidden = false
        sendtime.isHidden = false
        addressStack.isHidden = false
        addressCollection.isHidden = false
    }
    
    func cardCell() {
        self.cardID.removeAll()
        self.cardName.removeAll()
        self.cardPrice.removeAll()
        self.cardCategoryID.removeAll()
        self.cardUnitValue.removeAll()
        self.cardUnit.removeAll()
        self.cardImage.removeAll()
        self.cardsView.reloadData()
        if let ls = UserDefaults.standard.value(forKey:"cards") as? Data    {
            let res = try? PropertyListDecoder().decode(Array<SubViewController.shopingCards>.self, from: ls)
            cardClear.isHidden = false
            cardsView.isHidden = false
            productUnit.isHidden = false
            total.isHidden = false
            pay.isHidden = false
            for i in res!   {
                DispatchQueue.main.async{
                    self.bagImage.isHidden = true
                    self.cardEmptyInfo.isHidden = true
                    self.cardID.append(i.product_id)
                    self.cardName.append(i.product_name)
                    self.cardPrice.append(i.price)
                    self.cardCategoryID.append(i.category_id)
                    self.cardUnitValue.append(i.unit_value)
                    self.cardUnit.append(i.unit)
                    self.cardImage.append(i.getImage())
                    self.cardsView.reloadData()
                }
            }
        }
    }
    struct address: Codable {
        let response: Bool
        let data: addressData
    }
    
    struct addressData: Codable {
        let location_id, user_id, T_adres, socity_id: String
        let adress, receiver_name, receiver_mobile, socity_name: String
        let delivery_charge: String
    }
    
    @IBAction func mainPageSegueButton(_ sender: Any) {
    }
    
    func finishPost (message:String, data:Data?) -> Void
    {
        do
        {
            if let jsonData = data
            {
                let parsedData = try JSONDecoder().decode(dateResponse.self, from: jsonData)
                let firstData = parsedData.times.first
                let lastData = parsedData.times.last
                let lastSplit = lastData!.components(separatedBy: " -")
                let last = lastSplit[0]
                let lastDateData = last.components(separatedBy: ":")
                let lastTime = (lastDateData[0] + ":" + lastDateData[1])
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "HH:mm"
                let lastTimePicker = dateFormatter.date(from:lastTime)!
                let firstSplit = firstData!.components(separatedBy: " -")
                let first = firstSplit[0]
                let firstDateData = first.components(separatedBy: ":")
                let firstTime = (firstDateData[0] + ":" + firstDateData[1])
                dateFormatter.dateFormat = "HH:mm"
                let firstTimePicker = dateFormatter.date(from:firstTime)!
                DispatchQueue.main.async {
                    self.sendTimePicker.minimumDate = firstTimePicker
                    self.sendTimePicker.maximumDate = lastTimePicker
                }
                
                
            }
        }
        catch
        {
            print("Parse Error: \(error)")
        }
    }
    
    func finishPostAdress (message:String, data:Data?) -> Void
    {
        do
        {
            if let jsonData = data
            {
                let parsedData = try JSONDecoder().decode(address.self, from: jsonData)
                let addressData = parsedData.data
                
            }
        }
        catch
        {
            print("Parse Error: \(error)")
        }
    }
    
    func postTimeSlot(date: String) {
        let url = URL(string: "https://amasyaceliklermarket.com/api/get_time_slot/")
        ApiService.callPost(url: url!, params: ["date": date], finish: finishPost)
    }
    struct dateResponse: Codable {
        let response: Bool
        let times: [String]
    }
    
    struct dateStruct: Codable {
        let date: String
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == addressCollection  {
            return 3
        }
        return cardName.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == addressCollection   {
            let cell2 = collectionView.dequeueReusableCell(withReuseIdentifier: "adressCell", for: indexPath)
            return cell2
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellSepet", for: indexPath)
        if let vcImage = cell.viewWithTag(700) as? UIImageView {
            vcImage.image = cardImage[indexPath.row]
        }
        if let vcTitle = cell.viewWithTag(701) as? UILabel    {
            vcTitle.text = cardName[indexPath.row]
        }
        if let vcTotal = cell.viewWithTag(702) as? UILabel      {
            vcTotal.text = "Toplam: 0.0₺"
        }
        if let vcPrice = cell.viewWithTag(703) as? UILabel      {
            vcPrice.text = (cardPrice[indexPath.row]! + "₺")
        }
        return cell
    }
}

class ApiService
{
    static func getPostString(params:[String:Any]) -> String
    {
        var data = [String]()
        for(key, value) in params
        {
            data.append(key + "=\(value)")
        }
        return data.map { String($0) }.joined(separator: "&")
    }

    static func callPost(url:URL, params:[String:Any], finish: @escaping ((message:String, data:Data?)) -> Void)
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
