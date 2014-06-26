//
//  CircleView.swift
//  RegionMonitoringSwift
//
//  Created by Nicolas Flacco on 6/25/14.
//  Copyright (c) 2014 Nicolas Flacco. All rights reserved.
//

import Foundation
import UIKit
import QuartzCore

class CircleView: UIView {
    var width: CGFloat = 5.0
    
    init(frame: CGRect, width: CGFloat) {
        super.init(frame: frame)
        self.width = width
        
        // Set view to be transparent
        self.opaque = false;
        self.backgroundColor = UIColor(white: 0.0, alpha: 0.0);
    }
    
    override func drawRect(dirtyRect: CGRect) {
        
        
        
//        let context: CGContextRef = UIGraphicsGetCurrentContext()
//        CGContextSetLineWidth(context, width)
//        CGContextSetStrokeColorWithColor(context, UIColor.greenColor().CGColor)
//        CGContextAddEllipseInRect(context, self.frame)
//        CGContextSetFillColor(context, CGColorGetComponents(UIColor.greenColor().CGColor))
//        CGContextFillPath(context)
        
//        // Color Declarations
//        let strokeColor:UIColor = UIColor(red: 0, green: 0, blue: 1, alpha: 1)
//        strokeColor.setStroke()
//        
//        // Oval Drawing
//        let ovalPath:UIBezierPath = UIBezierPath(ovalInRect: CGRectMake(42.5, 65.5, 299, 289))
//        ovalPath.lineWidth = 3.5;
//        ovalPath.stroke()

//        println(dirtyRect)
//        var bPath:UIBezierPath = UIBezierPath(rect: dirtyRect)
//        println(bPath)
//        let fillColor = UIColor(red: 0.5, green: 0.0, blue: 0.5, alpha: 1.0)
//        fillColor.set()
//        bPath.fill()
//        
//        let borderColor = UIColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 1.0)
//        borderColor.set()
//        bPath.lineWidth = 12.0
//        bPath.stroke()
        
        
        let diameter:CGFloat = min(dirtyRect.size.width, dirtyRect.size.height) / 1.3
        let x:CGFloat = dirtyRect.size.width/2 - diameter/2
        let y:CGFloat = dirtyRect.size.height/2 - diameter/2
        
        var circleRect = CGRectMake(x, y, diameter, diameter)
//        var cPath:UIBezierPath = UIBezierPath(ovalInRect: circleRect)
        var cPath:UIBezierPath = UIBezierPath(rect: circleRect)
        
//        let circleFillColor = UIColor(red: 0.0, green: 1.0, blue: 0.0, alpha: 1.0)
//        circleFillColor.set()
//        cPath.fill()
        
        // Stroke circle
//        let strokeColor:UIColor = UIColor(red: 0.0, green: 1.0, blue: 0.0, alpha: 1.0)
//        strokeColor.setStroke()
//        cPath.lineWidth = 5.0
//        cPath.stroke()
        
        
        /*
        /// Bezier Drawing
        UIBezierPath* bezierPath = [UIBezierPath bezierPath];
        [bezierPath moveToPoint: CGPointMake(86.93, 108.93)];
        [bezierPath addCurveToPoint: CGPointMake(43.38, 225.7) controlPoint1: CGPointMake(54.92, 140.95) controlPoint2: CGPointMake(40.4, 183.83)];
        [bezierPath addCurveToPoint: CGPointMake(86.29, 107.82) controlPoint1: CGPointMake(38.66, 183.68) controlPoint2: CGPointMake(52.96, 140.04)];
        [bezierPath addCurveToPoint: CGPointMake(148.42, 71.75) controlPoint1: CGPointMake(104.26, 90.45) controlPoint2: CGPointMake(125.68, 78.42)];
        [bezierPath addCurveToPoint: CGPointMake(86.93, 108.93) controlPoint1: CGPointMake(125.92, 78.73) controlPoint2: CGPointMake(104.75, 91.12)];
        [bezierPath closePath];
        [strokeColor setStroke];
        bezierPath.lineWidth = 10;
        [bezierPath stroke];
*/
        
        /*
        let gradient:CAGradientLayer = CAGradientLayer()
        gradient.frame = circleRect
        gradient.cornerRadius = 5.0
        gradient.startPoint = CGPointMake(0.0, 0.5);
        gradient.endPoint = CGPointMake(1.0, 0.5);
        gradient.colors = [UIColor.clearColor().CGColor, UIColor.blueColor().CGColor, UIColor.clearColor().CGColor]
        self.layer.addSublayer(gradient)
        
        let anim:CAKeyframeAnimation = CAKeyframeAnimation(keyPath: "bounds")
        anim.path = cPath.CGPath
        anim.rotationMode = kCAAnimationRotateAuto;
        anim.repeatCount = HUGE;
        anim.speed = 1.0
        anim.duration = 2;
        gradient.addAnimation(anim, forKey: "gradient")
*/
        
        /*
        
        let diameter:CGFloat = min(dirtyRect.size.width, dirtyRect.size.height) / 1.3
        let x:CGFloat = dirtyRect.size.width/2 - diameter/2
        let y:CGFloat = dirtyRect.size.height/2 - diameter/2
        
        //// Color Declarations
        let strokeColor:UIColor = UIColor(red: 0.0, green: 1.0, blue: 0.0, alpha: 1.0)
        
        //// Oval Drawing
        var circlePath:UIBezierPath = UIBezierPath(ovalInRect: CGRectMake(20, 20, 300, 300))
        strokeColor.setStroke()
        circlePath.lineWidth = 10;
        circlePath.stroke()
        
        
        // Circle widget thingies
        var bezier1Path:UIBezierPath = UIBezierPath()
        bezier1Path.moveToPoint(CGPointMake(30, 170))
        bezier1Path.addCurveToPoint(CGPointMake(170, 30), controlPoint1: CGPointMake(30, 30), controlPoint2: CGPointMake(170, 30))
        bezier1Path.miterLimit = 0;
        strokeColor.setStroke()
        bezier1Path.lineWidth = 20;
        bezier1Path.stroke()
        
        var bezier2Path:UIBezierPath = UIBezierPath()
        bezier2Path.moveToPoint(CGPointMake(310, 170))
        bezier2Path.addCurveToPoint(CGPointMake(170, 310), controlPoint1: CGPointMake(310, 310), controlPoint2: CGPointMake(170, 310))
        bezier2Path.miterLimit = 0;
        strokeColor.setStroke()
        bezier2Path.lineWidth = 20;
        bezier2Path.stroke()
        
        let rotations:CGFloat = 10;
        let duration:CFTimeInterval = 5;
        
        let anim:CAKeyframeAnimation = CAKeyframeAnimation(keyPath: "transform.rotation")
        let touchUpStartAngle:CGFloat = 0;
        let touchUpEndAngle:CGFloat = CGFloat(M_PI);
        let angularVelocity:CGFloat = (((2 * CGFloat(M_PI)) * rotations) + CGFloat(M_PI)) / CGFloat(duration);
        anim.values = [touchUpStartAngle, (touchUpStartAngle + angularVelocity * CGFloat(duration))];
        anim.duration = duration;
        anim.autoreverses = false;
        anim.delegate = self;
        anim.repeatCount = HUGE ;
        anim.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        self.layer.addAnimation(anim, forKey:"test")
        
        self.transform = CGAffineTransformMakeRotation(touchUpStartAngle + (touchUpEndAngle));
        
        */

    }
}
