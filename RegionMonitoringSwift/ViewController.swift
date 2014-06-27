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
    var greenBeaconView: UIImageView?
    var purpleBeaconView: UIImageView?
    var greenBeaconDualView: UIImageView?
    var purpleBeaconDualView: UIImageView?
    var circleView: UIView?
    var label: UILabel?
    var scanButton: UIButton? // this is always on screen

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
        self.label = drawLabel(UIColor.whiteColor(), message: "Not in any Region")
        self.circleView = drawCircle(UIColor.blackColor())

        self.greenBeaconView = drawBeacon(beaconGreen)
        self.purpleBeaconView = drawBeacon(beaconPurple)
        self.greenBeaconDualView = drawBeacon(beaconGreen, left: true)
        self.purpleBeaconDualView = drawBeacon(beaconPurple, left: false)

        self.greenBeaconView!.hidden = true
        self.purpleBeaconView!.hidden = true
        self.greenBeaconDualView!.hidden = true
        self.purpleBeaconDualView!.hidden = true

        self.view.addSubview(self.circleView!)
        self.view.addSubview(self.greenBeaconView!)
        self.view.addSubview(self.purpleBeaconView!)
        self.view.addSubview(self.greenBeaconDualView!) // only when we are in both regions
        self.view.addSubview(self.purpleBeaconDualView!) // only when we are in both regions
        self.view.addSubview(self.label!)
        
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
            beaconList = Dictionary<String, Bool>() // wipe out dictionary
        } else {
            self.scanButton!.setImage(scanImgOn, forState: UIControlState.Normal)
            self.beaconManager!.start()
            self.beaconManager!.delegate = self
        }

        // Toggle scan mode
        self.scanMode = !self.scanMode
        self.setUI()
    }

    // BeaconManager Delegates and Helpers
    func insideRegion(regionIdentifier: String) {
//        println("VC insideRegion \(regionIdentifier)")
        self.beaconList[regionIdentifier] = true
        self.setUI()
    }

    func didEnterRegion(regionIdentifier: String) {
        println("VC didEnterRegion \(regionIdentifier)")
        self.beaconList[regionIdentifier] = true
        self.setUI()
        sendNotification("Entered region \(regionIdentifier)") // Only send notification when we enter
    }

    func didExitRegion(regionIdentifier: String) {
        println("VC didExitRegion \(regionIdentifier)")
        self.beaconList[regionIdentifier] = nil
        self.setUI()
    }

    // Generate the proper UI depending on the color passed in
    func setUI() {
        // TODO: Refactor
        if let green = self.beaconList["green"] {
            if let purple = self.beaconList["purple"] {
                // green and purple
                self.greenBeaconView!.hidden = true
                self.purpleBeaconView!.hidden = true
                self.greenBeaconDualView!.hidden = false
                self.purpleBeaconDualView!.hidden = false
                self.circleView!.backgroundColor = bothColor
                self.label!.text = "Inside Both Regions"
            } else {
                // green but not purple
                self.greenBeaconView!.hidden = false
                self.purpleBeaconView!.hidden = true
                self.greenBeaconDualView!.hidden = true
                self.purpleBeaconDualView!.hidden = true
                self.circleView!.backgroundColor = greenColor
                self.label!.text = "Inside Green Region"
            }
        } else {
            if let purple = self.beaconList["purple"] {
                // purple but not green
                self.greenBeaconView!.hidden = true
                self.purpleBeaconView!.hidden = false
                self.greenBeaconDualView!.hidden = true
                self.purpleBeaconDualView!.hidden = true
                self.circleView!.backgroundColor = purpleColor
                self.label!.text = "Inside Purple Region"
            } else {
                // neither green nor purple
                self.greenBeaconView!.hidden = true
                self.purpleBeaconView!.hidden = true
                self.greenBeaconDualView!.hidden = true
                self.purpleBeaconDualView!.hidden = true
                self.circleView!.backgroundColor = UIColor.blackColor()
                self.label!.text = "Not in any Region"
            }
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

