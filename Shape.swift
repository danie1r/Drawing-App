//
//  Shape.swift
//  CSE 438S Lab 3
//
//  Created by Michael Ginn on 5/31/21.
//

import UIKit

/**
 YOU SHOULD MODIFY THIS FILE.
 
 Feel free to implement it however you want, adding properties, methods, etc. Your different shapes might be subclasses of this class, or you could store information in this class about which type of shape it is. Remember that you are partially graded based on object-oriented design. You may ask TAs for an assessment of your implementation.
 */

/// A `DrawingItem` that draws some shape to the screen.
class Shape: DrawingItem {
    var center: CGPoint!
    var fillColor: UIColor!
    var path: UIBezierPath?
    var width: CGFloat!
    var angle: CGFloat!
    var scale: CGFloat!
    var opacity: CGFloat!
    public required init(origin: CGPoint, color: UIColor){
        self.center = origin
        self.fillColor = color
        self.path = UIBezierPath()
        self.width = 60
        self.angle = 0
        self.scale = 1
    }
    
    func draw() {
        
    }
    
    func contains(point: CGPoint) -> Bool {
        if let path=path{
            return path.contains(point)
        }
        return false
    }
}
extension UIBezierPath {
    func rotate(by angleRadians: CGFloat){
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        var transform = CGAffineTransform.identity
        transform = transform.translatedBy(x: center.x, y: center.y)
        transform = transform.rotated(by: angleRadians)
        transform = transform.translatedBy(x: -center.x, y: -center.y)
        self.apply(transform)
    }
    func scaleAroundCenter(factor: CGFloat) {
            let beforeCenter = CGPoint(x: self.bounds.midX, y: self.bounds.midY)

            let scaleTransform = CGAffineTransform(scaleX: factor, y: factor)
            self.apply(scaleTransform)

            let afterCenter = CGPoint(x: self.bounds.midX, y: self.bounds.midY)
            let diff = CGPoint( x: beforeCenter.x - afterCenter.x, y: beforeCenter.y - afterCenter.y)

            let translateTransform = CGAffineTransform(translationX: diff.x, y: diff.y)
            self.apply(translateTransform)
    }
}
