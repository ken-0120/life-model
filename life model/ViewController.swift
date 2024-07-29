//
//  ViewController.swift
//  life model
//
//  Created by student on 2024/05/03.
//
import AVFoundation
import UIKit
import CoreMotion
class ViewController: UIViewController {
    var audioplayer:AVAudioPlayer!
    let manager = CMMotionManager()
    var sensor = true
  
    @IBOutlet weak var xLabel: UILabel!
    @IBOutlet weak var yLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if sensor == true{
            if manager.isAccelerometerAvailable {
                manager.accelerometerUpdateInterval = 0.155
                var shake:Int = 0
                let accelerometerHandler: CMAccelerometerHandler = { [self] (data: CMAccelerometerData?, error: Error?) in
                    let magnitude = sqrt(pow(data?.acceleration.x ?? 0, 2) + pow(data?.acceleration.y ?? 0, 2) + pow(data?.acceleration.z ?? 0, 2))
                    if magnitude > 3.45{
                        shake += 1
                        let magnitude2 = magnitude * 10
                        self.xLabel.text = "\(round(magnitude2)/10)"
                        self.yLabel.text = "\(shake)"
                    }
                    if shake == 30{
                        audioplayer.stop()
                        self.manager.stopAccelerometerUpdates()
                        navigationController?.popViewController(animated: true)
                    }
                    print("x: \(data?.acceleration.x ?? 0) y: \(data?.acceleration.y ?? 0) z: \(data?.acceleration.z ?? 0)")
                }
                manager.startAccelerometerUpdates(to: OperationQueue.current!, withHandler: accelerometerHandler)
            }
        }
    }
}

