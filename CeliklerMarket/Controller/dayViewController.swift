//
//  dayViewController.swift
//  CeliklerMarket
//
//  Created by Ahmet Yusuf TOĞTAY on 5.06.2020.
//  Copyright © 2020 OzguRND. All rights reserved.
//

import UIKit

class dayViewController: UIViewController {

    var datee = Date()
    var timee = Date()
    var time: String = ""
    var dateString: String = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var dateTimePicker: UIDatePicker!
    
    @IBAction func DayButton(_ sender: Any) {
        timee = dateTimePicker.date
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        let timeString = formatter.string(from: timee)
        time = timeString
        performSegue(withIdentifier: "goBackDay", sender: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goBackDay" {
            let destination = segue.destination as! paymentViewController
            destination.dayString = time
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
