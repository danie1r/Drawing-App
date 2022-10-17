//
//  Square.swift
//  Lab3
//
//  Created by Daniel Ryu on 10/6/22.
//

import UIKit

class Square: Shape{
    
    required init(origin: CGPoint, color: UIColor){
        super.init(origin: origin, color: color)
    }
    override func draw() {
        if let path = path{
            path.removeAllPoints()
            fillColor.setFill()
            path.move(to: CGPoint(x: center.x-width, y: center.y-width))
            path.addLine(to: CGPoint(x: center.x-width, y: center.y+width))
            path.addLine(to: CGPoint(x: center.x+width, y: center.y+width))
            path.addLine(to: CGPoint(x: center.x+width, y: center.y-width))
            path.addLine(to: CGPoint(x: center.x-width, y: center.y-width))
            path.rotate(by: angle)
            path.scaleAroundCenter(factor: scale)
            if opacity != nil{
                path.fill(with: CGBlendMode.normal, alpha: opacity)
            } else {
                path.fill()
            }
        }
        
    }
}
