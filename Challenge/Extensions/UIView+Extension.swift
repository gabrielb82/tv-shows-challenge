//
//  UIView+Extension.swift
//  Challenge
//
//  Created by Gabriel Barbosa on 23/06/21.
//

import Foundation
import UIKit

extension UIView {

  /**
    Droping a shadow below the UIView creating an elevation effect
     
     i.e.: view.dropShadow(color: .red, opacity: 1, offSet: CGSize(width: -1, height: 1), radius: 3, scale: true)
     
     - Parameters:
        - color: The color of the shadow (UIColor)
        - opacity: The opacity of the shadow (Float - optional)
        - offSet: The offset of the shadow to be casted (CGSize)
        - radius: The radios of the shadow (CGFloat - optional)
        - scale: The scale of the shadow (Bool - optional)
     
     */
    func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offSet
        layer.shadowRadius = radius

        layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    /**
     Round the corners of a UIView
     */
    func roundedCorner(radius: CGFloat) {
        self.layer.cornerRadius = radius
    }
    
    /**
     Create a shake effect on the UIView
     
     */
    func shake() {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.05
        animation.repeatCount = 4
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: self.center.x - 10, y: self.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: self.center.x + 10, y: self.center.y))

        self.layer.add(animation, forKey: "position")
    }
}
