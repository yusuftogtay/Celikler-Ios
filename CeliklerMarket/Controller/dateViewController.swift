//
//  dateViewController.swift
//  CeliklerMarket
//
//  Created by Ahmet Yusuf TOĞTAY on 5.06.2020.
//  Copyright © 2020 OzguRND. All rights reserved.
//

import UIKit

class dateViewController: UIViewController {
    
    var datee = Date()
    var timee = Date()
    var time: String = ""
    var dateString: String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBOutlet weak var dateTimePicker: UIDatePicker!
    
    @IBAction func dayButton(_ sender: Any) {
        timee = dateTimePicker.date
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-dd"
        let timeString = formatter.string(from: timee)
        time = timeString
        print("bu gün \(timeString)")
        performSegue(withIdentifier: "goBackDay", sender: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goBackDay" {
            let destination = segue.destination as! paymentViewController
            destination.dayString = time
        }
    }
}
