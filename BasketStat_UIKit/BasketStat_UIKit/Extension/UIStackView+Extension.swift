//
//  UIStackView+Extension.swift
//  BasketStat_UIKit
//
//  Created by 김정원 on 8/17/24.
//

import Foundation
import UIKit

extension UIStackView {
    static func highlightStackView(for button: UIButton?) {
        guard let button = button, let stackView = button.superview as? UIStackView else { return }
        stackView.layer.borderColor = UIColor.orange.cgColor
        stackView.layer.borderWidth = 2
    }
    
    static func clearStackViewHighlight(for button: UIButton) {
        guard let stackView = button.superview as? UIStackView else { return }
        stackView.layer.borderColor = UIColor.clear.cgColor
        stackView.layer.borderWidth = 0
    }
}
