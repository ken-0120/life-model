//
//  FirstViewController.swift
//  life model
//
//  Created by student on 2024/07/0336.
//

import UIKit

class FirstViewController: UIViewController {
    var selectedWakeUpTime:Date?
    
    @IBOutlet weak var date: UIDatePicker!
    
    override func viewDidLoad() {
        print("FirstView")
        super.viewDidLoad()
        date.datePickerMode = .time
        date.setDate(Date(), animated: false)
        // Do any additional setup after loading the view.
    }
    @IBAction func completeSetup(_ sender: UIButton) {
        selectedWakeUpTime = date.date
        UserDefaults.standard.set(selectedWakeUpTime, forKey: "alarmTime")
        
        // メイン画面に遷移するなどの処理を行う
        performSegue(withIdentifier:"unko", sender: nil)
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
