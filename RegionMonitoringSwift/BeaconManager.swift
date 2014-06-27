//
//  BeaconManager.swift
//  RegionMonitoringSwift
//
//  Created by Nicolas Flacco on 6/25/14.
//  Copyright (c) 2014 Nicolas Flacco. All rights reserved.
//

import CoreLocation
import UIKit

// config
// General search criteria for beacons that are broadcasting
let BEACON_SERVICE_NAME = "estimote"
let BEACON_PROXIMITY_UUID = NSUUID(UUIDString: "B9407F30-F5F8-466E-AFF9-25556B57FE6D")

// Beacons are hardcoded into our app so we can easily filter for them in a noisy environment
let BEACON_PURPLE_MAJOR: CLBeaconMajorValue = 15071
let BEACON_PURPLE_MINOR: CLBeaconMinorValue = 10507
let BEACON_GREEN_MAJOR: CLBeaconMajorValue = 45565
let BEACON_GREEN_MINOR: CLBeaconMinorValue = 64072

protocol BeaconManagerDelegate {
    func insideRegion(regionIdentifier: String)
    func didEnterRegion(regionIdentifier: String)
    func didExitRegion(regionIdentifier: String)
}

class BeaconManager: NSObject, CLLocationManagerDelegate    {
    var locationManager: CLLocationManager = CLLocationManager()
    let registeredBeaconMajor = [BEACON_GREEN_MAJOR, BEACON_PURPLE_MAJOR]

    let greenRegion: CLBeaconRegion = CLBeaconRegion(proximityUUID:BEACON_PROXIMITY_UUID, major: BEACON_GREEN_MAJOR, identifier:"green")
    let purpleRegion: CLBeaconRegion = CLBeaconRegion(proximityUUID: BEACON_PROXIMITY_UUID, major: BEACON_PURPLE_MAJOR, identifier: "purple")
    var delegate: BeaconManagerDelegate?
    
    class var sharedInstance:BeaconManager {
    return sharedBeaconManager
    }
    
    init() {
        super.init()
        locationManager.delegate = self
    }
    
    func start() {
        println("BM start");
        locationManager.startMonitoringForRegion(greenRegion, desiredAccuracy: kCLLocationAccuracyBest)
        locationManager.startMonitoringForRegion(purpleRegion, desiredAccuracy: kCLLocationAccuracyBest)
    }
    
    func stop() {
        println("BM stop");
        locationManager.stopMonitoringForRegion(greenRegion)
        locationManager.stopMonitoringForRegion(purpleRegion)
    }
    
    //  CLLocationManagerDelegate methods
    
    func locationManager(manager: CLLocationManager!, didStartMonitoringForRegion region: CLRegion!) {
        println("BM didStartMonitoringForRegion")
        locationManager.requestStateForRegion(region) // should locationManager be manager?
    }
    
    func locationManager(manager: CLLocationManager, didEnterRegion:CLRegion) {
        println("BM didEnterRegion \(didEnterRegion.identifier)")
        delegate?.didEnterRegion(didEnterRegion.identifier)
    }
    
    func locationManager(manager: CLLocationManager, didExitRegion:CLRegion) {
        println("BM didExitRegion \(didExitRegion.identifier)")
        delegate?.didExitRegion(didExitRegion.identifier)
    }
    
    func locationManager(manager: CLLocationManager!, didDetermineState state: CLRegionState, forRegion region: CLRegion!) {
        println("BM didDetermineState \(state)");
        
        switch state {
        case .Inside:
            println("BeaconManager:didDetermineState CLRegionState.Inside \(region.identifier)");
            delegate?.insideRegion(region.identifier)
        case .Outside:
            println("BeaconManager:didDetermineState CLRegionState.Outside");
        case .Unknown:
            println("BeaconManager:didDetermineState CLRegionState.Unknown");
        default:
            println("BeaconManager:didDetermineState default");
        }
    }

    func locationManager(manager: CLLocationManager!, didRangeBeacons beacons: CLBeacon[]!, inRegion region: CLBeaconRegion!) {
//        println("BM didRangeBeacons");
    }
}


let sharedBeaconManager = BeaconManager()