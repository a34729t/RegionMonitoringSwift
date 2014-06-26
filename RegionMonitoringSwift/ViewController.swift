//
//  ViewController.swift
//  RegionMonitoringSwift
//
//  Created by Nicolas Flacco on 6/25/14.
//  Copyright (c) 2014 Nicolas Flacco. All rights reserved.
//

import CoreLocation
import UIKit
import QuartzCore

class ViewController: UIViewController {
    var beaconManager: BeaconManager?
    
    override func viewDidLoad() {
        println("viewDidLoad")
        
        super.viewDidLoad()
        // Do any additional setup after loading the view
        
        self.beaconManager = sharedBeaconManager
//        self.beaconManager!.start()
        if !CLLocationManager.locationServicesEnabled() {
            // TODO: Alert, once alerts work without crashing app
        }
        
        // Draw UI elements
//        let circleView:CircleView = CircleView(frame: self.view.frame, width: 5.0)
//        circleView.alpha = 0.25;
//        self.view.addSubview(circleView);
        
        let circleView:UIView = UIView(frame: CGRectMake(10,20,100,100))
        circleView.alpha = 0.5;
        circleView.layer.cornerRadius = 50;
        circleView.backgroundColor = UIColor.greenColor()
        self.view.addSubview(circleView);
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

