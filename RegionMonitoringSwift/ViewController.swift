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

class ViewController: UIViewController, BeaconManagerDelegate {
    // Singleton to manage location updates/ranging
    var beaconManager: BeaconManager?
    var beaconList = Dictionary<String, Bool>() // major+minor -> yes or no

    // UI elements
    var beaconView: UIImageView?
    var beaconView2: UIImageView?
    var circleView: UIView?
    var label: UILabel?
    var scanButton: UIButton?

    // General config
    var scanMode: Bool = false

    // UI colors and images
    // let blueColor:UIColor = UIColor(red: 0.42, green: 0.75, blue: 0.87, alpha: 1.0) // No blue iBeacon
    let greenColor:UIColor = UIColor(red: 0.49, green: 0.64, blue: 0.55, alpha: 1.0)
    let purpleColor:UIColor = UIColor(red: 0.4, green: 0.34, blue: 0.65, alpha: 1.0)
    let bothColor:UIColor = UIColor(red: 0.8, green: 0.2, blue: 0.8, alpha: 1.0)
    let circleAlpha:CGFloat = 0.75
    let beaconGreen = UIImage(named: "beaconGreen.png")
    let beaconPurple = UIImage(named: "beaconPurple.png")


    override func viewDidLoad() {
        println("viewDidLoad")
        
        super.viewDidLoad()
        // Do any additional setup after loading the view

        // Configure UI
        self.setUI() // Default, not in any region
        self.view.addSubview(self.circleView)
        self.view.addSubview(self.beaconView)
        self.view.addSubview(self.beaconView2) // only when we are in both regions
        self.view.addSubview(self.label)

        
        self.beaconManager = sharedBeaconManager
        if !CLLocationManager.locationServicesEnabled() {
            // TODO: Alert, once alerts work without crashing app
        }

        // Make scan button (antenna)
        let scanButton: UIButton = makeMenuButton(image: scanImgOff, left:false, size:self.view.frame.size)
        scanButton.addTarget(self, action: "scanButtonClicked:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(scanButton)
        self.scanButton = scanButton

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // Button Handler
    func scanButtonClicked(sender: UIButton!) {
        println("scanButtonClicked")

        // Change 1) color of button 2) enable/disable beacon manager
        if self.scanMode {
            self.scanButton!.setImage(scanImgOff, forState: UIControlState.Normal)
            self.beaconManager!.stop()
            self.beaconManager!.delegate = nil
        } else {
            self.scanButton!.setImage(scanImgOn, forState: UIControlState.Normal)
            self.beaconManager!.start()
            self.beaconManager!.delegate = self
        }

        // Toggle scan mode
        self.scanMode = !self.scanMode
    }


    // BeaconManager Delegates and Helpers
    func insideRegion(regionIdentifier: String) {
        println("VC insideRegion \(regionIdentifier)")
        self.beaconList[regionIdentifier] = true
        self.setUI()
    }

    func didEnterRegion(regionIdentifier: String) {
        println("VC didEnterRegion \(regionIdentifier)")
        self.beaconList[regionIdentifier] = true
        self.setUI()
    }

    func didExitRegion(regionIdentifier: String) {
        println("VC didExitRegion \(regionIdentifier)")
        self.beaconList[regionIdentifier] = false
        self.setUI()
    }

    // Generate the proper UI depending on the color passed in
    func setUI() {
        switch (self.beaconList["green"], self.beaconList["purple"]) {
        case (let green, .None):
            self.beaconView = drawBeacon(beaconGreen)
            self.beaconView2 = nil
            self.circleView = drawCircle(greenColor)
            self.label = drawLabel(greenColor, message: "Inside Green Region")
        case (.None, let purple):
            self.beaconView = drawBeacon(beaconPurple)
            self.beaconView2 = nil
            self.circleView = drawCircle(purpleColor)
            self.label = drawLabel(purpleColor, message: "Inside Purple Region")
        case (let green, let purple):
            self.beaconView = drawBeacon(beaconGreen, left: true)
            self.beaconView2 = drawBeacon(beaconPurple, left: false)
            self.circleView = drawCircle(bothColor)
            self.label = drawLabel(bothColor, message: "Inside Both Regions")
        default:
            self.beaconView = nil
            self.beaconView2 = nil
            self.circleView = nil
            self.label = drawLabel(UIColor.whiteColor(), message: "Not in any Region")
        }
    }

    // View Helpers (move to utils?)

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

        let diameter:CGFloat = min(self.view.bounds.size.width, self.view.bounds.size.height) / 1.1
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

    func drawBeacon(image:UIImage, left:Bool) -> UIImageView {

        //        let scale:CGFloat = min(self.view.bounds.size.width, self.view.bounds.size.height)
        let width = image.size.width
        let height = image.size.height
        var x, y: CGFloat
        if left {
            x = (self.view.bounds.size.width / 2) - (width / 2) - (width / 2.5)
            y = (self.view.bounds.size.height / 1.7) - (height / 2) - (height / 2.5)
        } else {
            x = (self.view.bounds.size.width / 2) - (width / 2) + (width / 2.5)
            y = (self.view.bounds.size.height / 1.7) - (height / 2) + (height / 2.5)
        }

        let imageView: UIImageView = UIImageView(frame: CGRect(x: x, y: y, width: width, height: height))
        imageView.image = image
        imageView.contentMode = UIViewContentMode.ScaleAspectFit

        return imageView;
    }
    
}

