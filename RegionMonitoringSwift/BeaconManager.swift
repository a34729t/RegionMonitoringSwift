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
let BEACON_PURPLE_MAJOR = "15071"
let BEACON_PURPLE_MINOR = "10507"
let BEACON_GREEN_MAJOR = "45565"
let BEACON_GREEN_MINOR = "64072"

protocol BeaconManagerDelegate {
    func discoveredBeacon(#major: String, minor: String, proximity: CLProximity) // NOTE: #major forces first parameter to be named in function call
}

class BeaconManager: NSObject, CLLocationManagerDelegate    {
    var locationManager: CLLocationManager = CLLocationManager()
    let registeredBeaconMajor: String[] = [BEACON_GREEN_MAJOR, BEACON_PURPLE_MAJOR]
    let estimoteRegion: CLBeaconRegion = CLBeaconRegion(proximityUUID:BEACON_PROXIMITY_UUID, identifier:"Estimote Region")
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
        locationManager.startMonitoringForRegion(estimoteRegion)
    }
    
    func stop() {
        println("BM stop");
        locationManager.stopMonitoringForRegion(estimoteRegion)
    }
    
    //  CLLocationManagerDelegate methods
    
    func locationManager(manager: CLLocationManager!, didStartMonitoringForRegion region: CLRegion!) {
        println("BM didStartMonitoringForRegion");
        locationManager.requestStateForRegion(region); // should locationManager be manager?
    }
    
    func locationManager(manager: CLLocationManager, didEnterRegion:CLRegion) {
        println("BM didEnterRegion \(didEnterRegion)");
    }
    
    func locationManager(manager: CLLocationManager, didExitRegion:CLRegion) {
        println("BM didExitRegion \(didExitRegion)");
    }
    
    func locationManager(manager: CLLocationManager!, didDetermineState state: CLRegionState, forRegion region: CLRegion!) {
        println("BM didDetermineState \(state)");
        
        switch state {
        case .Inside:
            println("BeaconManager:didDetermineState CLRegionState.Inside");
            locationManager.startRangingBeaconsInRegion(estimoteRegion) // should locationManager be manager?
        case .Outside:
            println("BeaconManager:didDetermineState CLRegionState.Outside");
        case .Unknown:
            println("BeaconManager:didDetermineState CLRegionState.Unknown");
        default:
            println("BeaconManager:didDetermineState default");
        }
    }
    
    func locationManager(manager: CLLocationManager!, didRangeBeacons beacons: CLBeacon[]!, inRegion region: CLBeaconRegion!) {
        println("BM didRangeBeacons");
        
        for beacon: CLBeacon in beacons {
            // TODO: better way to unwrap optionals?
            if let major: String = beacon.major?.stringValue? {
                if let minor: String = beacon.minor?.stringValue? {
                    let contained: Bool = contains(registeredBeaconMajor, major)
                    let active: Bool = (UIApplication.sharedApplication().applicationState == UIApplicationState.Active)
                    if contained && active {
                        delegate?.discoveredBeacon(major: major, minor: minor, proximity: beacon.proximity)
                    }
                }
            }
        }
    }
}


let sharedBeaconManager = BeaconManager()