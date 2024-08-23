//
//  UIButton+Extension.swift
//  BasketStat_UIKit
//
//  Created by 김정원 on 8/17/24.
//

import Foundation
import UIKit
import Then
import SnapKit

extension UIButton {
    
    static func createStatButton(stat: Stat) -> UIButton {
        let button = UIButton().then {
            $0.setTitle(stat.rawValue, for: .normal)
            $0.titleLabel?.font = UIFont.boldButton
            $0.backgroundColor = .clear
            $0.setTitleColor(.white, for: .normal)
            $0.layer.cornerRadius = 5
            $0.layer.borderColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.3).cgColor
            $0.layer.borderWidth = 1
            $0.layer.masksToBounds = true
            
            $0.snp.makeConstraints { make in
                make.height.equalTo(40)
            }
        }
        return button
    }
    
    static func createPlayerButton(backNumber: Int) -> UIButton {
        let button = UIButton().then {
            $0.setTitle("\(backNumber)", for: .normal)
            $0.titleLabel?.font = UIFont.regular3
            $0.backgroundColor = .white
            $0.setTitleColor(.black, for: .normal)
            $0.layer.cornerRadius = 5
            $0.layer.masksToBounds = true
            $0.snp.makeConstraints { make in
                make.width.equalTo(50)
                make.height.equalTo(40)
            }
        }
        return button
    }
    
    static func highlightButton(_ button: UIButton?) {
        button?.layer.borderWidth = 4
        button?.layer.borderColor = UIColor.orange.cgColor
    }
    
    static func clearButtonHighlight(for button: UIButton) {
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.3).cgColor
    }
}
