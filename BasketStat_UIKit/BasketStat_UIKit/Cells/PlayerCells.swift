//
//  PlayerCells.swift
//  BasketStat_UIKit
//
//  Created by 양승완 on 8/6/24.
//

import Foundation
import UIKit
import Then
import SnapKit

class PlayerBuilderCell: UITableViewCell {
    
    var nameLabel : UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        return label
        
    }()
    let numberLabel = {
        let label = UILabel()
        label.textAlignment = .center
        return label
        
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .clear
        self.setUI()
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUI() {
        self.contentView.addSubview(nameLabel)
        self.contentView.addSubview(numberLabel)
        
        self.numberLabel.snp.makeConstraints {
            $0.centerY.leading.equalTo(self.contentView)
            $0.trailing.equalTo(self.contentView.snp.centerX)
        }
        
        self.nameLabel.snp.makeConstraints {
            $0.centerY.trailing.equalTo(self.contentView)
            $0.leading.equalTo(self.contentView.snp.centerX)
        }
        
        
        
    }
    
}
class PlayerSearchCell: UITableViewCell {
    
    var nameLabel = UILabel().then {
        $0.textAlignment = .center
        $0.textColor = .mainWhite()
    }
    var positionLabel = UILabel().then {
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
        self.contentView.addSubview(nameLabel)
        self.contentView.addSubview(profileImage)
        self.contentView.addSubview(positionLabel)
        
        self.profileImage.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(10)
            $0.width.height.equalTo(50)
        }
        
        self.nameLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(self.profileImage.snp.trailing).offset(10)
        }
        self.positionLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(10)
        }
        
        
        
        
        
    }
    
}
