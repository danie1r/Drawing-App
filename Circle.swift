//
//  Circle.swift
//  Lab3
//
//  Created by Daniel Ryu on 10/6/22.
//

import UIKit

class Circle: Shape{
    
    
    required init(origin:CGPoint, color: UIColor){
        super.init(origin: origin, color: color)
    }
    
    
    override func draw() {
        if let path = path{
            path.removeAllPoints()
            fillColor.setFill()
            path.addArc(withCenter: center, radius: width, startAngle: 0, endAngle: CGFloat(Float.pi * 2), clockwise: true)
            path.scaleAroundCenter(factor: scale)
            if opacity != nil{
                path.fill(with: CGBlendMode.normal, alpha: opacity)
            } else {
                path.fill()
            }
            
        }
    }
}
