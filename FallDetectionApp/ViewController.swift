//
//  ViewController.swift
//  FallDetectionApp
//
//  Created by Pavani Baradi on 11/26/16.
//  Copyright © 2016 Pavani Baradi. All rights reserved.
//

import UIKit
import CoreMotion

class ViewController: UIViewController {
    
    @IBOutlet weak var label: UILabel!
    var altimeter: CMAltimeter!
    var accelerometer: CMAcceleration!
    var motionManager: CMMotionManager!

    override func viewDidLoad() {
        super.viewDidLoad()
        altimeter = CMAltimeter()
        accelerometer = CMAcceleration()
        self.motionManager = CMMotionManager()
        //self.startAccelerometer()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func start(_ sender: Any) {
        self.startAccelerometer()
    }
    @IBAction func stop(_ sender: Any) {
        self.stopAccelerometer()
        self.label.text = "Label"
    }
    
    func startAccelerometer(){
        motionManager.accelerometerUpdateInterval = 0.2
        if motionManager.isAccelerometerAvailable {
            motionManager.startAccelerometerUpdates(to: OperationQueue.current!, withHandler: { accelerometerData, error in
                let acceleration = accelerometerData?.acceleration
                
                let magnitude = sqrt(pow((acceleration?.x)!, 2) + pow((acceleration?.y)!, 2) + pow((acceleration?.z)!, 2))
                let x = (acceleration?.x)!
                let y = (acceleration?.y)!
                let z = (acceleration?.z)!
                print((acceleration?.x)!)
                print((acceleration?.y)!)
                print((acceleration?.z)!)
                print(" sum is \(x + y + z))")
                print("magnitude is \(magnitude)")
                
                if magnitude < 0.05 {
                    print("fall detected")
                    self.label.text = "Fall Detected"
                }
                
            })
        }
    }
    
    
    func stopAccelerometer(){
        motionManager.stopAccelerometerUpdates()
    }

}

