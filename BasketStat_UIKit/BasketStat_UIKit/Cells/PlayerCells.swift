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
import RxSwift
class PlayerBuilderCell: UITableViewCell {
    
    var nameLabel = UILabel().then {
        $0.textAlignment = .right
        $0.textColor = .mainWhite()
        $0.font = .regular4
    }
    let numberLabel = UILabel().then {
        $0.textAlignment = .right
        $0.textColor = .mainWhite()
        $0.font = .regular4


        
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
        self.contentView.addSubview(numberLabel)
        
        self.numberLabel.snp.makeConstraints {
            $0.centerY.equalTo(self.contentView)
            $0.leading.equalToSuperview().inset(10)

        }
        
        self.nameLabel.snp.makeConstraints {
            $0.centerY.equalTo(self.contentView)
            $0.trailing.equalToSuperview().inset(10)
        }
        
        
        
    }
    
}
class PlayerSearchCell: UITableViewCell {
    
    var disposeBag = DisposeBag()
    
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

class PlayerAddCell: UITableViewCell {
    
    let plusImage = UIImageView(image: UIImage(systemName: "plus")).then {
        $0.tintColor = .mainWhite()
  
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .mainColor().withAlphaComponent(0.2)
        self.setUI()
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUI() {
        self.addSubview(plusImage)
        
        self.plusImage.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.height.equalTo(40)
        }

    }
}



