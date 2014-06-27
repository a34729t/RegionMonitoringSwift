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
    // Singleton to manage location updates/ranging
    var beaconManager: BeaconManager?

    // UI elements
    var beaconView: UIImageView?
    var circleView: UIView?
    var label: UILabel?

    // UI colors and images
    // let blueColor:UIColor = UIColor(red: 0.42, green: 0.75, blue: 0.87, alpha: 1.0) // No blue iBeacon
    let greenColor:UIColor = UIColor(red: 0.49, green: 0.64, blue: 0.55, alpha: 1.0)
    let purpleColor:UIColor = UIColor(red: 0.4, green: 0.34, blue: 0.65, alpha: 1.0)
    let circleAlpha:CGFloat = 0.75
    let beaconGreen = UIImage(named: "beaconGreen.png")
    let beaconPurple = UIImage(named: "beaconPurple.png")

    override func viewDidLoad() {
        println("viewDidLoad")
        
        super.viewDidLoad()
        // Do any additional setup after loading the view
        
        self.beaconManager = sharedBeaconManager
//        self.beaconManager!.start()
        if !CLLocationManager.locationServicesEnabled() {
            // TODO: Alert, once alerts work without crashing app
        }
        

        // Draw UI?
        self.beaconView = drawBeacon(beaconPurple)
        self.circleView = drawCircle(purpleColor)
        self.label = drawLabel(purpleColor, message: "Inside Purple Region")

        self.view.addSubview(circleView);
        self.view.addSubview(beaconView);
        self.view.addSubview(label)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // View Helpers

    func drawLabel(color:UIColor, message:String) -> UILabel {
        var label = UILabel(frame: CGRectMake(0, 0, 400, 100))
        label.center = CGPointMake(self.view.bounds.size.width / 2, 50)
        label.textAlignment = NSTextAlignment.Center
        label.text = message
        label.textColor = color
        label.font = UIFont.systemFontOfSize(30)
        return label
    }

    func drawCircle(color:UIColor) -> UIView {

        let diameter:CGFloat = min(self.view.bounds.size.width, self.view.bounds.size.height) / 1.2
        let x = (self.view.bounds.size.width / 2) - (diameter / 2)
        let y = (self.view.bounds.size.height / 1.7) - (diameter / 2)

        let circleView:UIView = UIView(frame: CGRectMake(x, y, diameter, diameter))
        circleView.layer.cornerRadius = diameter / 2;
        circleView.backgroundColor = color
        circleView.alpha = circleAlpha

        return circleView;
    }

    func drawBeacon(image:UIImage) -> UIImageView {

//        let scale:CGFloat = min(self.view.bounds.size.width, self.view.bounds.size.height)
        let width = image.size.width
        let height = image.size.height
        let x = (self.view.bounds.size.width / 2) - (width / 2)
        let y = (self.view.bounds.size.height / 1.7) - (height / 2)

        let imageView: UIImageView = UIImageView(frame: CGRect(x: x, y: y, width: width, height: height))
        imageView.image = image
        imageView.contentMode = UIViewContentMode.ScaleAspectFit

        return imageView;
    }
    
}

