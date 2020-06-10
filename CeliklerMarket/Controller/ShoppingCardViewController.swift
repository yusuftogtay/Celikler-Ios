//
//  ShoppingCardViewController.swift
//  CeliklerMarket
//
//  Created by Ahmet Yusuf TOĞTAY on 26.05.2020.
//  Copyright © 2020 OzguRND. All rights reserved.
//

import UIKit

class ShoppingCardViewController: UIViewController,  UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITableViewDelegate, UITableViewDataSource {
    
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
    var soCityId = "0"
    var socityId = [String?]()
    var location_id = [String?]()
    
    var date: Date?
    var time: Date?
    var dayStringType: String?
    var timeStringType: String?
    var daySelect = false
   
    var odeme: String?
    
    @IBOutlet weak var navbar: UINavigationBar!
    @IBOutlet weak var cardClear: UIButton!
    @IBOutlet weak var cardsView: UICollectionView!
    @IBOutlet weak var pay: UIButton!
    @IBOutlet weak var bagImage: UIImageView!
    @IBOutlet weak var cardEmptyInfo: UILabel!
    @IBOutlet weak var MainPageSegueButton: UIButton!
    @IBOutlet weak var sendDay: UIButton!
    @IBOutlet weak var sendtime: UIButton!
    @IBOutlet weak var sendDayPicker: UIDatePicker!
    @IBOutlet weak var sendTimePicker: UIDatePicker!
    @IBOutlet weak var selectDay: UIButton!
    @IBOutlet weak var addressCollection: UICollectionView!
    @IBOutlet weak var pay2: UIButton!
    @IBOutlet weak var selectTime: UIButton!
    @IBOutlet weak var addressStack: UIStackView!
    @IBOutlet weak var paymentStack: UIStackView!
    @IBOutlet weak var kapidaNakitSwitch: UISwitch!
    @IBOutlet weak var kapidaCardSwitch: UISwitch!
    @IBOutlet weak var cardsInfo: UIStackView!
    @IBOutlet weak var addressTable: UITableView!
    var soityId = [String?]()
    var sendData: [send] = []
    
    
    
    @IBAction func nakit(_ sender: Any) {
        let state = kapidaNakitSwitch.isOn
        if state    {
            kapidaCardSwitch.isOn = false
            odeme = "Teslimatta Nakit"
        }   else    {
            kapidaCardSwitch.isOn = true
            odeme = "Teslimatta Banka/Kredi"
        }
    }
    @IBAction func card(_ sender: Any) {
        let state = kapidaCardSwitch.isOn
        if state    {
            kapidaNakitSwitch.isOn = false
            odeme = "Teslimatta Banka/Kredi"
        }   else    {
            kapidaNakitSwitch.isOn = true
            odeme = "Teslimatta Nakit"
        }
    }
    
    override func viewDidLoad() {
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        super.viewDidLoad()
        odeme = "Teslimatta Nakit"
        addressTable.delegate = self
        addressTable.dataSource = self
        daySelect = false
        let nullCheck = UserDefaults.standard.value(forKey: "cards")
        if nullCheck == nil     {
            card(hidden: true)
            paymnent(hidden: true)
            time(hidden: true)
            day(hidden: true)
            nullcard(hidden: true)
        }   else {
            cardCellGenerate()
            day(hidden: true)
            card(hidden: false)
            paymnent(hidden: true)
            time(hidden: true)
            nullcard(hidden: false)
        }
        
        odeme = "Teslimatta Nakit"
    
    }
    
    //Hiding Methods
    func paymnent(hidden: Bool) {
        if hidden {
            sendDay.isHidden = true
            sendtime.isHidden = true
            addressStack.isHidden = true
            addressTable.isHidden = true
            paymentStack.isHidden = true
            pay2.isHidden = true
        } else {
            sendDay.isHidden = false
            sendtime.isHidden = false
            addressStack.isHidden = false
            addressTable.isHidden = false
            paymentStack.isHidden = false
            pay2.isHidden = false
        }
    }
    
    func card(hidden: Bool) {
        if hidden {
            cardClear.isHidden = true
            cardsView.isHidden = true
            cardsInfo.isHidden = true
            pay.isHidden = true
        }   else {
            cardClear.isHidden = false
            cardsView.isHidden = false
            cardsInfo.isHidden = false
            pay.isHidden = false
        }
        
    }
    
    func time(hidden: Bool) {
        if hidden {
            selectTime.isHidden = true
            sendTimePicker.isHidden = true
        }   else {
            selectTime.isHidden = false
            sendTimePicker.isHidden = false
        }
    }
    
    func day(hidden: Bool) {
        if hidden {
            selectDay.isHidden = true
            sendDayPicker.isHidden = true
        }   else {
            selectDay.isHidden = false
            sendDayPicker.isHidden = false
        }
    }
    
    @objc func doSomething(refreshControl: UIRefreshControl) {
        refreshControl.endRefreshing()
    }
    
    @IBAction func payDone(_ sender: Any) {
        let user = UserDefaults.standard.value(forKey: "userID")
        let selectedIndexPath = addressTable.indexPathForSelectedRow
        if timeStringType != nil {
            if selectedIndexPath != nil {
                let index = selectedIndexPath![1]
                let location = location_id[index]
                var time = timeStringType!.components(separatedBy: ":")
                var lastTime = "\(Int(time[1])! + 30)"
                if lastTime == "60" {
                    lastTime = "00"
                    time[0] = "\(Int(time[0])! + 1)"
                    if time[0] == "24"  {
                        time[0] = "00"
                    }
                }
                let lastttime = "\(time[0]):\(lastTime)"
                let postTime = "\(timeStringType!) - \(lastttime)"
                
                do  {
                    let data = try JSONEncoder().encode(sendData)
                    if let JSONString = String(data: data, encoding: String.Encoding.utf8) {
                        print(JSONString)
                       let params: [String: Any] = [
                           "user_id": user!,
                           "date": dayStringType!,
                           "time": postTime,
                           "data": JSONString,
                           "location": location!,
                           "payment_method": odeme!,
                       ]
                        let url = URL(string: "https://amasyaceliklermarket.com/api/send_order")
                        ApiService.callPost(url: url!, params: params, finish: sendOrderResponse)
                    }
                } catch {
                    print(error)
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
    
    func sendOrderResponse(message:String, data:Data?) -> Void
    {
        do
        {
            if let jsonData = data
            {
                if let JSONString = String(data: jsonData, encoding: String.Encoding.utf8) {
                   print(JSONString)
                }
                let parsedData = try JSONDecoder().decode(sendOrder.self, from: jsonData)
                if parsedData.response == true{
                   
                    let alert = UIAlertController(title: "Siparişniz Başarıyla Alınmıştır", message: parsedData.data, preferredStyle: .alert)
                    
                    
                    let action = UIAlertAction(title: "Tamam", style: .default, handler: { (action: UIAlertAction!) in
                        
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
    
    @IBAction func selectDay(_ sender: Any) {
        date = sendDayPicker.date
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-dd"
        let dayString = formatter.string(from: date!)
        postTimeSlot(date: dayString)
        dayStringType = dayString
        day(hidden: true)
        card(hidden: true)
        paymnent(hidden: false)
        time(hidden: true)
        nullcard(hidden: false)
        daySelect = true
    }
    @IBAction func selectTime(_ sender: Any) {
        time = sendTimePicker.date
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        let timeString = formatter.string(from: time!)
        timeStringType = timeString
        day(hidden: true)
        card(hidden: true)
        paymnent(hidden: false)
        time(hidden: true)
        nullcard(hidden: false)
        
    }
    
    @IBAction func sendDay(_ sender: Any) {
        day(hidden: false)
        card(hidden: true)
        paymnent(hidden: true)
        time(hidden: true)
        nullcard(hidden: false)
    }
    
    @IBAction func sendTime(_ sender: Any) {
        if daySelect {
            day(hidden: true)
            card(hidden: true)
            paymnent(hidden: true)
            time(hidden: false)
            nullcard(hidden: false)
        }   else    {
            let alert = UIAlertController(title: "Bilgilendirme", message: "İlk önce Teslimat Gününü Seçin", preferredStyle: .alert)
            let action = UIAlertAction(title: "Tamam", style: .default, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
    func nullcard(hidden: Bool) {
        if hidden {
            bagImage.isHidden = false
            MainPageSegueButton.isHidden = false
            cardEmptyInfo.isHidden = false
        }   else {
            bagImage.isHidden = true
            MainPageSegueButton.isHidden = true
            cardEmptyInfo.isHidden = true
        }
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
        card(hidden: true)
        time(hidden: true)
        day(hidden: true)
        nullcard(hidden: true)
    }
    @IBAction func addressEkle(_ sender: Any) {
        performSegue(withIdentifier: "goAddress", sender: nil)
    }
    
    @IBAction func pay(_ sender: Any) {
        day(hidden: true)
        card(hidden: true)
        paymnent(hidden: false)
        time(hidden: true)
        nullcard(hidden: false)
    }
    
    func cardCellGenerate() {
        self.cardID.removeAll()
        self.cardName.removeAll()
        self.cardPrice.removeAll()
        self.cardCategoryID.removeAll()
        self.cardUnitValue.removeAll()
        self.cardUnit.removeAll()
        self.cardImage.removeAll()
        self.cardsView.reloadData()
        if let ls = UserDefaults.standard.value(forKey:"cards") as? Data    {
            let res = try? PropertyListDecoder().decode(Array<shopingCards>.self, from: ls)
            sendData.removeAll()
            for i in res!   {
                DispatchQueue.main.async{
                    self.cardID.append(i.product_id)
                    self.cardName.append(i.product_name)
                    self.cardPrice.append(i.price)
                    self.cardCategoryID.append(i.category_id)
                    self.cardUnitValue.append(i.unit_value)
                    self.cardUnit.append(i.unit)
                    self.cardImage.append(i.getImage())
                    self.cardsView.reloadData()
                    let card = send(product_id: i.product_id, qty: i.unit, unit_value: i.unit_value, unit: i.product_unit, price: i.price)
                    self.sendData.append(card)
                }
            }
        }
    }
    
    @IBAction func mainPageSegueButton(_ sender: Any) {
        self.performSegue(withIdentifier: "anasayfa", sender: nil)
    }
    
    func finishPostTime (message:String, data:Data?) -> Void
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
    
    func finishPostAddress (message:String, data:Data?) -> Void
    {
        do
        {
            if let jsonData = data
            {
                let parseData = try JSONDecoder().decode(address.self, from: jsonData)
                if parseData.response == true   {
                    let addressData = parseData.data
                    for i in addressData    {
                        DispatchQueue.main.async {
                            self.addressReceiverName.append(i.receiver_name)
                            self.addressReceiverPhone.append(i.receiver_mobile)
                            self.addresssocity.append(i.socity_name)
                            self.deliveryCharge.append(i.delivery_charge)
                            self.socityId.append(i.socity_id)
                            self.location_id.append(i.location_id)
                            self.addressTable.reloadData()

                        }
                    }
                }
            }
        }
        catch
        {
            print("Parse Error: \(error)")
        }
    }
    
    func postTimeSlot(date: String) {
        let url = URL(string: "https://amasyaceliklermarket.com/api/get_time_slot/")
        ApiService.callPost(url: url!, params: ["date": date], finish: finishPostTime)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return addressReceiverPhone.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableCell = addressTable.dequeueReusableCell(withIdentifier: "addressCell", for: indexPath)
        if let name = tableCell.viewWithTag(10) as? UILabel    {
            name.text = addressReceiverName[indexPath.row]
        }
        if let phone = tableCell.viewWithTag(12) as? UILabel    {
            phone.text = addressReceiverPhone[indexPath.row]
        }
        if let socity = tableCell.viewWithTag(11) as? UILabel    {
            socity.text = addresssocity[indexPath.row]
        }
        if let charge = tableCell.viewWithTag(13) as? UILabel    {
            charge.text = deliveryCharge[indexPath.row]!
        }
        return tableCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        soCityId = socityId[indexPath.row]!
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cardName.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cardCell", for: indexPath)
        if let vcImage = cell.viewWithTag(700) as? UIImageView {
            vcImage.image = cardImage[indexPath.row]
        }
        if let vcTitle = cell.viewWithTag(701) as? UILabel    {
            vcTitle.text = cardName[indexPath.row]
        }
        if let vcTotal = cell.viewWithTag(702) as? UILabel      {
            vcTotal.text = cardUnitValue[indexPath.row]
        }
        if let vcPrice = cell.viewWithTag(703) as? UILabel      {
            vcPrice.text = (cardPrice[indexPath.row]! + "₺")
        }
        if let vcPrice = cell.viewWithTag(704) as? UILabel      {
            vcPrice.text = cardUnit[indexPath.row]!
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = collectionView.frame.size
        return CGSize(width: size.width, height: (size.height/5))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
