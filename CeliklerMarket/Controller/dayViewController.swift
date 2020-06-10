//
//  dayViewController.swift
//  CeliklerMarket
//
//  Created by Ahmet Yusuf TOĞTAY on 5.06.2020.
//  Copyright © 2020 OzguRND. All rights reserved.
//

import UIKit

protocol dayViewControllerDelegate
{
    func dayViewControllerResponse(day: String)
}

class dayViewController: UIViewController {

    var datee = Date()
    var timee = Date()
    var time: String = ""
    var dateString: String = ""
    var delegate: dayViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    @IBAction func dayPicker(_ sender: Any) {
    }
    
    @IBAction func dayButton(_ sender: Any) {
        //timee = dateTimePicker.date
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        let timeString = formatter.string(from: timee)
        time = timeString
        if let firstViewController = self.navigationController?.viewControllers.first {
            self.navigationController?.popToViewController(firstViewController, animated: true)
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goBackDay" {
            let destination = segue.destination as! paymentViewController
            destination.dayString = time
        }
    }
}
