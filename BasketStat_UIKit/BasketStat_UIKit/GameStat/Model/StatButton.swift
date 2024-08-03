//
//  StatButton.swift
//  BasketStat_UIKit
//
//  Created by 김정원 on 8/3/24.
//

import Foundation
import UIKit
import Then
import SnapKit

struct StatButton {
    
    func makeButton(title: String) -> UIButton {
        return UIButton().then {
            $0.setTitle(title, for: .normal)
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
    }
    
}
