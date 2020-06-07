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
        super.viewDidLoad()
        let url = URL(string: "https://amasyaceliklermarket.com/api/get_time_slot/")
        ApiService.callPost(url: url!, params: ["date": day], finish: finishPostTime)
    }
    
    @IBAction func timepicker(_ sender: Any) {
        
    }
    
    @IBAction func timebutton(_ sender: Any) {
        timee = timePicker.date
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        let timeString = formatter.string(from: timee)
        time = timeString
        print(time)
        performSegue(withIdentifier: "goBackTime", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goBackTime" {
            let destination = segue.destination as! paymentViewController
            destination.timeString = time
            destination.dayString = day
        }
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
                }
            }
        }
        catch
        {
            print("Parse Error: \(error)")
        }
    }
}
