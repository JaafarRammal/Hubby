//
//  ProgressCircle.swift
//  Hubby
//
//  Created by Jaafar Rammal on 06/02/2022.
//

import UIKit

@IBDesignable
class ProgressCircleView: UIView {
    
    @IBInspectable
    var scale: CGFloat = 0.9
    
    @IBInspectable
    var lineWidth: CGFloat = 20
    
    @IBInspectable
    var containerCircleColor: UIColor = UIColor.systemTeal.withAlphaComponent(0.4)
    
    @IBInspectable
    var animatedCircleColor: UIColor = UIColor.systemTeal
    
    @IBInspectable
    var animationDuration: Double = 0.5
    
    var completion: CGFloat = CGFloat(progress/getTarget())
    
    private let shapeLayer = CAShapeLayer()
    
    private var animationStartAngle: CGFloat = 3 * CGFloat.pi / 2
    
    private var animationEndAngle: CGFloat {
        if (completion >= 1) {
            return CGFloat(359 - 90).degreesToRadians
        }
        let degrees = completion * 360  - 90
        return degrees.degreesToRadians
    }
    
    private var circleRadius: CGFloat {
        return min(bounds.size.width, bounds.size.height) / 2 * scale
    }
    
    private var circleCenter: CGPoint {
        return CGPoint(x: bounds.midX, y: bounds.midY)
    }

    private func pathForCircle(startAngle start: CGFloat, endAngle end: CGFloat) -> UIBezierPath {
        let path = UIBezierPath(arcCenter: circleCenter, radius: circleRadius, startAngle: start, endAngle: end, clockwise: true)
        path.lineWidth = lineWidth
        return path
    }
    
    public func animateCircle() {
        completion = (CGFloat(progress))/(CGFloat(getTarget()))
        print(completion)
        shapeLayer.strokeColor = animatedCircleColor.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = lineWidth
        shapeLayer.lineCap = CAShapeLayerLineCap.round
        self.layer.addSublayer(shapeLayer)
        shapeLayer.path = pathForCircle(startAngle: animationStartAngle, endAngle: animationEndAngle).cgPath
        
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = 0.0
        animation.toValue = 1.0
        animation.duration = animationDuration
        shapeLayer.add(animation, forKey: "drawLineAnimation")
    }
    
    override func draw(_ rect: CGRect) {
        containerCircleColor.set()
        pathForCircle(startAngle: 0, endAngle: 2*CGFloat.pi).stroke()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.animateCircle()
        }
    }
}

extension CGFloat {
    var degreesToRadians: CGFloat { return self * .pi / 180 }
    var radiansToDegrees: CGFloat { return self * 180 / .pi }
}
