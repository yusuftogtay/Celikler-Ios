//
//  dateViewController.swift
//  CeliklerMarket
//
//  Created by Ahmet Yusuf TOĞTAY on 5.06.2020.
//  Copyright © 2020 OzguRND. All rights reserved.
//

import UIKit

protocol dateViewControllerDelegate
{
    func dateViewControllerResponse(day: String)
}

class dateViewController: UIViewController {
    
    var datee = Date()
    var timee = Date()
    var time: String = ""
    var dateString: String = ""
    var delegate: dateViewControllerDelegate?
    
    override func viewDidLoad() {
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        super.viewDidLoad()
        dayButton.layer.cornerRadius = 6.0
        dateTimePicker.minimumDate = Date()
    }
    
    @IBOutlet weak var dayButton: UIButton!
    @IBOutlet weak var dateTimePicker: UIDatePicker!
    
    @IBAction func dayButton(_ sender: Any) {
        timee = dateTimePicker.date
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-dd"
        let timeString = formatter.string(from: timee)
        time = timeString
    }
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destVC = segue.destination as! paymentViewController
        destVC.dayString = time
    }
    @IBAction func dayPicker(_ sender: Any) {
        timee = dateTimePicker.date
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-dd"
        let timeString = formatter.string(from: timee)
        time = timeString
    }
}
