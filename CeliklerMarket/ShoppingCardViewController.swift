//
//  ShoppingCardViewController.swift
//  CeliklerMarket
//
//  Created by Ahmet Yusuf TOĞTAY on 26.05.2020.
//  Copyright © 2020 OzguRND. All rights reserved.
//

import UIKit

class ShoppingCardViewController: UIViewController {
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Date
        
        
        
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.date(from:"2020:02:02")
        
        sendDayPicker.minimumDate = Date()
        //sendDayPicker.maximumDate =
        sendDayPicker.date = Date()
        sendDayPicker.datePickerMode = .date
        //Time
        sendTimePicker.minuteInterval = 30
        let timeFormatter = DateFormatter()
        dateFormatter.dateFormat = "'HH':'mm'"
        let time = dateFormatter.date(from: "10:00")
        sendTimePicker.maximumDate = time
        //UIHidden
        sendTimePicker.isHidden = true
        sendDayPicker.isHidden = true
        selectDay.isHidden = true
        notEmptyCard()
    }
    
    @IBAction func sendDay(_ sender: Any) {
        deliveryInformationHide()
        sendDayPicker.isHidden = false
        selectDay.isHidden = false
    }
    @IBAction func selectDay(_ sender: Any) {
        date = sendDayPicker.date
        print(date)
        postTimeSlot(date: date!)
    }
    
    @IBAction func sendTime(_ sender: Any) {
        
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
    }
    
    @IBAction func pay(_ sender: Any) {
        if let data = UserDefaults.standard.value(forKey:"cards") as? Data {
            let res = try? PropertyListDecoder().decode(Array<SubViewController.shopingCards>.self, from: data)
            let dataa = res![0] as? SubViewController.shopingCards
        }
        
    }
    
    @IBAction func mainPageSegueButton(_ sender: Any) {
    }
    
    func postTimeSlot(date: Date) {
        
    }
}
