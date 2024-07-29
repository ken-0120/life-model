//
//  HomeViewController.swift
//  life model
//
//  Created by student on 2024/05/31.
//
import UserNotifications
import AVFoundation
import UIKit
import Combine
import CoreData

class HomeViewController: UIViewController {
   
    let alarm = Alarm()
    let defaults = UserDefaults.standard
    let url = Bundle.main.path(forResource: "Dawn_Birds_Deliberate_V1", ofType: "mp3")
    var clockTimer: Timer!
    var audioPlayer: AVAudioPlayer!
    var selectedWakeUpTime:Date?
    var seconds = 0
    var isProcessing: Bool = false
    var timer: Timer?
    var backgroundTaskIdentifier: UIBackgroundTaskIdentifier = UIBackgroundTaskIdentifier(rawValue: 0)
    private var oldBackgroundTaskID: UIBackgroundTaskIdentifier = UIBackgroundTaskIdentifier(rawValue: 0)

    var workItem = DispatchWorkItem{}
    var aaaaaa = 0
    //--------------------------------------------------------------------
    @IBOutlet weak var TimeLsbel: UILabel!
    @IBOutlet weak var AlarmSwtich: UISwitch!

    @IBAction func LoadAlarmSetting(_ sender: Any) {
        workItem.cancel()
        EndBackGround()
        aaaaaa = 0
    }
   //--------------------------------------------------------------------
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Active alarm" {
            let next = segue.destination as? ViewController
            next?.audioplayer = audioPlayer
        }
    }
    //--------------------------------------------------------------------
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let time = UserDefaults.standard.object(forKey: "alarmTime") as? Date {
            selectedWakeUpTime = time
        }else {
            selectedWakeUpTime = nil
        }
        remakeWorkItem()
        AlarmSwtich.isOn = true
        AlarmSwtich.addTarget(self, action: #selector(switchValueChanged(_:)), for: .valueChanged)
        if AlarmSwtich.isOn && aaaaaa == 0{
            isProcessing = true
            alarmactive()
        }
        clockTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { (timer) in self.tick() } )
        
        do {
            let sound:URL = URL(fileURLWithPath:self.url!)
            audioPlayer = try AVAudioPlayer(contentsOf: sound, fileTypeHint:nil)
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [])
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Cannot load file")
        }
        
    }
    //--------------------------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        remakeWorkItem()
    }
    //--------------------------------------------------------------------
    @objc func switchValueChanged(_ sender: UISwitch) {
        if sender.isOn{
            isProcessing = true
            remakeWorkItem()
            alarmactive()
            
        }else{
            aaaaaa = 0
            EndBackGround()
            workItem.cancel()
            isProcessing = false
            
            
        }
    }
    //--------------------------------------------------------------------
    func remakeWorkItem() {
        workItem = DispatchWorkItem{
            while self.seconds > 1{
                self.seconds -= 1
                print(self.seconds)
                if self.workItem.isCancelled {
                    return
                }
                sleep(1)
            }
                self.audioPlayer?.numberOfLoops = -1
                self.audioPlayer?.play()
                self.endBackgroundTask()
        }
    }
    //--------------------------------------------------------------------
    func alarmactive() {
        start()
        sleep(1)
        seconds = calculateInterval(userAwakeTime: selectedWakeUpTime!)
        let content = UNMutableNotificationContent()
        content.title = "アラーム"
        content.body = "時間です！"
        content.sound = UNNotificationSound.default
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval:TimeInterval(seconds), repeats: false)
        let request = UNNotificationRequest(identifier: "alarmNotification", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("通知のスケジュールに失敗しました: \(error.localizedDescription)")
            } else {
                print("通知をスケジュールしました")
            }
        }
        DispatchQueue.global().async(execute: workItem)
    }
    //--------------------------------------------------------------------
    func start(interval: Double = 60) {
        timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            
            // 古いバックグラウンドタスクのIDを保存
            let oldBackgroundTaskID = self.backgroundTaskIdentifier
            
            // 新しいバックグラウンドタスクを登録
            self.backgroundTaskIdentifier = UIApplication.shared.beginBackgroundTask {
                // バックグラウンドタスクが期限切れになった時の処理
                UIApplication.shared.endBackgroundTask(self.backgroundTaskIdentifier)
                self.backgroundTaskIdentifier = UIBackgroundTaskIdentifier.invalid
            }
            
            // 古いバックグラウンドタスクを終了
            if oldBackgroundTaskID != UIBackgroundTaskIdentifier.invalid {
                UIApplication.shared.endBackgroundTask(oldBackgroundTaskID)
            }
        }
    }
    //--------------------------------------------------------------------
    func tick() {
        let date = Date()
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.timeStyle = .short
        let dateStr = formatter.string(from: date)
        TimeLsbel.font = UIFont(name: "Arial-BoldMT", size: 20.0)
        TimeLsbel.text = dateStr
    }
    //--------------------------------------------------------------------
    private func calculateInterval(userAwakeTime: Date) -> Int {
        let currentDate = Date()
        let calendar = Calendar.current
        let currentComponents = calendar.dateComponents([.year, .month, .day], from: currentDate)
        let userComponents = calendar.dateComponents([.hour, .minute], from: userAwakeTime)
        guard let combinedDate = calendar.date(from: currentComponents)?.addingTimeInterval(TimeInterval(userComponents.hour! * 3600 + userComponents.minute! * 60)) else {
            print("Failed to combine date and time.")
            return 0
        }
        var interval = Int(combinedDate.timeIntervalSinceNow)
        
        if interval < 0 {
            interval = 86400 - (0 - interval)
        }
        let seconds = calendar.component(.second, from: combinedDate)
        return interval - seconds
    }
    //--------------------------------------------------------------------
    func end() {
          timer?.invalidate()
          timer = nil
     
          
      }
    func endBackgroundTask() {
        timer?.invalidate()
        timer = nil
        sleep (1)
        if(seconds > 0){
            return
        }
        UIApplication.shared.endBackgroundTask(backgroundTaskIdentifier)
        UIApplication.shared.endBackgroundTask(oldBackgroundTaskID)
        backgroundTaskIdentifier = .invalid
            DispatchQueue.main.async {
                print("perform")
                self.performSegue(withIdentifier:"Active alarm", sender: nil)
                self.alarmactive()
                self.aaaaaa = 1
            }
    }
    //--------------------------------------------------------------------
    func EndBackGround() {
        timer?.invalidate()
        timer = nil
        UIApplication.shared.endBackgroundTask(backgroundTaskIdentifier)
        UIApplication.shared.endBackgroundTask(oldBackgroundTaskID)
        backgroundTaskIdentifier = .invalid
    }
}
