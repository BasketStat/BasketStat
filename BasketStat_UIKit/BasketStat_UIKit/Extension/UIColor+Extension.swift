//
//  UIColor+Extension.swift
//  BasketStat_UIKit
//
//  Created by 김정원 on 7/9/24.
//
import UIKit

extension UIColor {
    
    // MARK: 색상변환 메서드
    class func fromRGB(_ r:Double, _ g: Double, _ b: Double, _ a: Double) -> UIColor {
        return UIColor(red: CGFloat(r / 255.0), green: CGFloat(g / 255.0), blue: CGFloat(b / 255.0), alpha: CGFloat(a))
    }
    
    class func mainColor() -> UIColor {
        return .fromRGB(58, 53, 48, 1)
    }
    
    class func customOrange() -> UIColor {
        return UIColor(red: 0.922, green: 0.4, blue: 0.02, alpha: 1)
    }
    class func mainWhite() -> UIColor {
        return UIColor.white.withAlphaComponent(0.5)
    }
    
}
