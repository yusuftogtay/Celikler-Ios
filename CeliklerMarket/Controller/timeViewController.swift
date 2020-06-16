//
//  timeViewController.swift
//  CeliklerMarket
//
//  Created by Ahmet Yusuf TOĞTAY on 5.06.2020.
//  Copyright © 2020 OzguRND. All rights reserved.
//

import UIKit

class timeViewController: UIViewController {

    
    @IBOutlet weak var timePicker: UIDatePicker!
    var day: String = ""
    var time: String = ""
    var timee = Date()
    override func viewDidLoad() {
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        super.viewDidLoad()
        let url = URL(string: "https://amasyaceliklermarket.com/api/get_time_slot/")
        ApiService.callPost(url: url!, params: ["date": day], finish: finishPostTime)
        timee = timePicker.date
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        let timeString = formatter.string(from: timee)
        time = timeString
        timeButton.layer.cornerRadius = 6.0
        timePicker.setDate(Date(), animated: true)
    }
    
    @IBAction func timepicker(_ sender: Any) {
        
    }
    
    @IBAction func timebutton(_ sender: Any) {
        timee = timePicker.date
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        let timeString = formatter.string(from: timee)
        time = timeString
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destVC = segue.destination as! paymentViewController
        destVC.timeString = time
        destVC.dayString = day
    }
    
    @IBOutlet weak var timeButton: UIButton!
    
    
    @IBAction func timePicker(_ sender: Any) {
        timee = timePicker.date
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        let timeString = formatter.string(from: timee)
        time = timeString
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
                    self.timePicker.minimumDate = firstTimePicker
                    self.timePicker.maximumDate = lastTimePicker
                    self.timePicker.setDate(firstTimePicker, animated: true)
                }
            }
        }
        catch
        {
            print("Parse Error: \(error)")
        }
    }
}
