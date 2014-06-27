//
//  Utils.swift
//  RegionMonitoringSwift
//
//  Created by Nicolas Flacco on 6/27/14.
//  Copyright (c) 2014 Nicolas Flacco. All rights reserved.
//

import Foundation
import UIKit

// Image constants
//let backgroundImage = UIImage(named: "sandycay")
let menuIconImage = UIImage(named: "menuIcon.png")
let scanIconImage = UIImage(named: "scanIcon.png")
let beaconGreen = UIImage(named: "beaconGreen.png")
let beaconPurple = UIImage(named: "beaconPurple.png")

// Icons in on/off mode
let menuImgOff = filledImageFrom(image: menuIconImage, UIColor.grayColor())
let menuImgOn = filledImageFrom(image: menuIconImage, UIColor.whiteColor())
let scanImgOff = filledImageFrom(image: scanIconImage, UIColor.grayColor())
let scanImgOn = filledImageFrom(image: scanIconImage, UIColor.whiteColor())

// local notifications
let NOTIF_KEY = "WILLIAM_GIBSON_IS_AWESOME"

func makeMenuButton(#image: UIImage, #left: Bool, #size: CGSize) -> UIButton {
    let menuWidth: CGFloat = 150/3;
    let menuHeight: CGFloat = 133/3;
    let menuPadding: CGFloat = 10;

    let button: UIButton = UIButton.buttonWithType(UIButtonType.Custom) as UIButton
    if (left) {
        button.frame = CGRectMake( menuPadding , size.height - menuHeight - menuPadding, menuWidth, menuHeight);
    } else {
        button.frame = CGRectMake(size.width - menuWidth - menuPadding, size.height - menuHeight - menuPadding, menuWidth, menuHeight);
    }
    button.setImage(image, forState: UIControlState.Normal)

    return button;

}

//  Helpers
// From http://stackoverflow.com/questions/845278/overlaying-a-uiimage-with-a-color?lq=1
func filledImageFrom(#image:UIImage, color:UIColor) -> UIImage {
    // begin a new image context, to draw our colored image onto with the right scale
    UIGraphicsBeginImageContextWithOptions(image.size, false, UIScreen.mainScreen().scale)

    // get a reference to that context we created
    let context:CGContextRef = UIGraphicsGetCurrentContext()

    // set the fill color
    color.setFill()

    // translate/flip the graphics context (for transforming from CG* coords to UI* coords
    CGContextTranslateCTM(context, 0, image.size.height)
    CGContextScaleCTM(context, 1.0, -1.0)

    CGContextSetBlendMode(context, kCGBlendModeColorBurn)
    let rect:CGRect = CGRectMake(0, 0, image.size.width, image.size.height)
    CGContextDrawImage(context, rect, image.CGImage)

    CGContextSetBlendMode(context, kCGBlendModeSourceIn)
    CGContextAddRect(context, rect)
    CGContextDrawPath(context,kCGPathFill)

    // generate a new UIImage from the graphics context we drew onto
    let coloredImg:UIImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()

    //return the color-burned image
    return coloredImg
}

func sendNotification(message: String) {
    let notification:UILocalNotification = UILocalNotification()
    let timeZone = NSTimeZone.defaultTimeZone()

    notification.fireDate = NSDate()
    notification.timeZone = timeZone
    notification.alertBody = message;
    notification.alertAction = "Show";  //creates button that launches app
    notification.soundName = UILocalNotificationDefaultSoundName;
    notification.applicationIconBadgeNumber = UIApplication.sharedApplication().applicationIconBadgeNumber + 1

    // to pass information with notification
    let userDict:Dictionary = [NOTIF_KEY:message]
    notification.userInfo = userDict;
    UIApplication.sharedApplication().scheduleLocalNotification(notification);
}