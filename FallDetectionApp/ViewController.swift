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
    func startAltimeter() {
        
        print("Started relative altitude updates.")
        
        // Check if altimeter feature is available
        if (CMAltimeter.isRelativeAltitudeAvailable()) {
            
            // Start altimeter updates, add it to the main queue
            self.altimeter.startRelativeAltitudeUpdates(to: OperationQueue.main, withHandler: { (altitudeData:CMAltitudeData?, error:Error?) in
                
                if (error != nil) {
                    self.stopAltimeter()
                    
                } else {
                    
                    let altitude = altitudeData!.relativeAltitude.floatValue    // Relative altitude in meters
                    let pressure = altitudeData!.pressure.floatValue            // Pressure in kilopascals
                    
                    print(altitude)
                    print(pressure)
                }
            })
            
        } else {
            print("Barometer not available on this device.")
        }
        
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
    
    func startDeviceMotion(){
        motionManager.deviceMotionUpdateInterval = 0.2
        if motionManager.isDeviceMotionAvailable {
            motionManager.startDeviceMotionUpdates(to: OperationQueue.current!, withHandler: {
                motionData, error in
                print(motionData!.gravity)
            })
        }
    }
    
    func startGyroscope(){
        motionManager.gyroUpdateInterval = 0.2
        if motionManager.isGyroAvailable {
            motionManager.startGyroUpdates(to: OperationQueue.current!, withHandler: { gyroData, error in
                
                let gyro = gyroData?.rotationRate
                print((gyro?.x)!)
                print((gyro?.y)!)
                print((gyro?.z)!)
                
                let magnitude = sqrt(pow((gyro?.x)!, 2) + pow((gyro?.y)!, 2) + pow((gyro?.z)!, 2))
                print("magnitude is \(magnitude)")
                if magnitude > 1 {
                    print("Fall Detected")
                    self.label.text = "Fall Detected"
                    return
                }
            })
        }
    }
    
    func stopGyroscope(){
        motionManager.stopGyroUpdates()
    }
    
    func stopAccelerometer(){
        motionManager.stopAccelerometerUpdates()
    }

    
    func stopAltimeter() {
        self.altimeter.stopRelativeAltitudeUpdates()
        print("Stopped relative altitude updates.")
        
    }
    
    func stopDeviceMotion(){
        motionManager.stopDeviceMotionUpdates()
    }

}

