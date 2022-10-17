//
//  StrokeSquare.swift
//  Lab3
//
//  Created by Daniel Ryu on 10/7/22.
//

import UIKit

class StrokeSquare: Shape{
    
    required init(origin: CGPoint, color: UIColor){
        super.init(origin: origin, color: color)
    }
    override func draw() {
        if let path = path{
            path.removeAllPoints()
            path.move(to: CGPoint(x: center.x-width, y: center.y-width))
            path.addLine(to: CGPoint(x: center.x-width, y: center.y+width))
            path.addLine(to: CGPoint(x: center.x+width, y: center.y+width))
            path.addLine(to: CGPoint(x: center.x+width, y: center.y-width))
            path.addLine(to: CGPoint(x: center.x-width, y: center.y-width))
            path.rotate(by: angle)
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
