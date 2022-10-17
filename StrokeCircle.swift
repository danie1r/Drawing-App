//
//  StrokeCircle.swift
//  Lab3
//
//  Created by Daniel Ryu on 10/7/22.
//

import UIKit

class StrokeCircle: Shape{
    
    
    required init(origin:CGPoint, color: UIColor){
        super.init(origin: origin, color: color)
    }
    
    
    override func draw() {
        if let path = path{
            path.removeAllPoints()
            path.addArc(withCenter: center, radius: width, startAngle: 0, endAngle: CGFloat(Float.pi * 2), clockwise: true)
            path.scaleAroundCenter(factor: scale)
            fillColor.setStroke()
            if opacity != nil{
                path.stroke(with: CGBlendMode.normal, alpha: opacity)
            } else {
                path.stroke()
            }
        }
    }
}
