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
    
    override func drawRect(rect: CGRect) {
        let diameter:CGFloat = min(rect.size.width, rect.size.height) / 1.3
        let x:CGFloat = rect.size.width/2 - diameter/2
        let y:CGFloat = rect.size.height/2 - diameter/2
        
        var circleRect = CGRectMake(x, y, diameter, diameter)
        var cPath:UIBezierPath = UIBezierPath(rect: circleRect)
    }
}
