//
//  UISegment+Extension.swift
//  BasketStat_UIKit
//
//  Created by 김정원 on 8/17/24.
//
import Then
import SnapKit
import UIKit
import Foundation

extension UISegmentedControl {
    
    static func createSegmentControls() -> UISegmentedControl {
        return UISegmentedControl(items: ["성공", "실패"]).then {
           // $0.selectedSegmentIndex = 0
            let normalTextAttributes: [NSAttributedString.Key: Any] = [
                .foregroundColor: UIColor.lightGray,
                .font: UIFont.boldButton
            ]
            $0.setTitleTextAttributes(normalTextAttributes, for: .normal)
            let selectedTextAttributes: [NSAttributedString.Key: Any] = [
                .foregroundColor: UIColor.fromRGB(255, 107, 0, 0.9),
                .font: UIFont.boldButton
            ]
            $0.setTitleTextAttributes(selectedTextAttributes, for: .selected)
            $0.selectedSegmentTintColor = UIColor.mainColor()
            $0.backgroundColor = .clear
            $0.layer.cornerRadius = 5
            $0.layer.masksToBounds = true
            $0.selectedSegmentIndex = UISegmentedControl.noSegment
            $0.isEnabled = false
            $0.snp.makeConstraints { make in
                make.height.equalTo(25)
            }
        }
    }
}

