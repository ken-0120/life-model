//
//  AlarmsetViewController.swift
//  life model
//
//  Created by student on 2024/06/28.
//

import UIKit

class AlarmsetViewController: UIViewController {
    var selectedWakeUpTime:Date?
    
    @IBOutlet var sleepTimePicker: UIDatePicker!
    @IBOutlet weak var BacktoHome: UIButton!
    @IBAction func BacktoHome(sender: Any) {
        selectedWakeUpTime = sleepTimePicker.date
        UserDefaults.standard.set(selectedWakeUpTime, forKey: "alarmTime")
        print("timer set")
        navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sleepTimePicker.datePickerMode = .time
        sleepTimePicker.setDate(Date(), animated: false)
        //let isFirstLaunch = UserDefaults.standard.bool(forKey: "isFirstLaunch")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let time = UserDefaults.standard.object(forKey: "alarmTime") as? Date {
            sleepTimePicker.date = time
        }
    }
}
