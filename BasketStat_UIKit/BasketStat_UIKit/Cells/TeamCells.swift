//
//  TeamCells.swift
//  BasketStat_UIKit
//
//  Created by 양승완 on 8/21/24.
//

import Foundation
import UIKit
import Then
import SnapKit
import RxSwift

class TeamSearchCell: UITableViewCell {
    
    
    var nameLabel = UILabel().then {
        $0.textAlignment = .center
        $0.textColor = .mainWhite()
    }
 
    let profileImage = UIImageView().then {
        $0.backgroundColor = .gray
        $0.layer.cornerRadius = 25
        $0.clipsToBounds = true
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .clear
        self.setUI()
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUI() {
        self.contentView.addSubview(self.nameLabel)
        self.contentView.addSubview(self.profileImage)
        
        self.profileImage.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(10)
            $0.width.height.equalTo(50)
        }
        
        self.nameLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(self.profileImage.snp.trailing).offset(10)
        }
   

    }
    
}
