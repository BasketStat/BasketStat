//
//  UIFont+Extension.swift
//  BasketStat_UIKit
//
//  Created by 김정원 on 7/16/24.
//

import Foundation
import UIKit
extension UIFont {
    static var h0b = UIFont(name: "Pretendard-Bold", size: 24) ?? UIFont.systemFont(ofSize: 24, weight: .bold)
    static var h1b = UIFont(name: "Pretendard-Bold", size: 20) ?? UIFont.systemFont(ofSize: 20, weight: .bold)
    /// 28
    static var regular1 = UIFont(name: "Pretendard-Regular", size: 28) ?? UIFont.systemFont(ofSize: 28, weight: .regular)
    /// 24
    static var regular2 = UIFont(name: "Pretendard-Regular", size: 24) ?? UIFont.systemFont(ofSize: 24, weight: .regular)
    /// 20
    static var regular3 = UIFont(name: "Pretendard-Regular", size: 20) ?? UIFont.systemFont(ofSize: 20, weight: .regular)
    
    /// size 14
    static var regular4 = UIFont(name: "Pretendard-Regular", size: 14) ?? UIFont.systemFont(ofSize: 14, weight: .regular)
    
    static var boldButton = UIFont(name: "Pretendard-Bold", size: 14) ?? UIFont.systemFont(ofSize: 14, weight: .bold)
    
    static var black1 = UIFont(name: "Pretendard-Black", size: 14) ?? UIFont.systemFont(ofSize: 14, weight: .bold)
    
    static var regularButton = UIFont(name: "Pretendard-Regular", size: 14) ?? UIFont.systemFont(ofSize: 14, weight: .regular)
    
    static func customBoldFont(size: Int) -> UIFont {
        return UIFont(name: "Pretendard-Bold", size: CGFloat(size)) ?? UIFont.systemFont(ofSize: CGFloat(size), weight: .bold)
    }
    
    static func customFont(fontName: String ,size: Int) -> UIFont {
        return UIFont(name: fontName, size: CGFloat(size)) ?? UIFont.systemFont(ofSize: CGFloat(size), weight: .bold)
    }
    
    
}
