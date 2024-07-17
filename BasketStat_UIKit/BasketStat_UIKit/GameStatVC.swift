//
//  GameStatVC.swift
//  BasketStat_UIKit
//
//  Created by 김정원 on 7/16/24.
//

import UIKit
import Then
import SnapKit

class GameStatVC: UIViewController {

    let backgroundImage = UIImageView().then {
        $0.image = UIImage(named: "background")!
        $0.contentMode = .scaleAspectFill
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    let quarterLabel = UILabel().then {
        $0.text = "1Q"
        $0.frame = CGRect(x: 0, y: 0,width: 84, height: 76)
        $0.textColor = .white
        $0.font = UIFont.systemFont(ofSize: 64, weight: .bold)
    }
    
    let firstTeamSpaceView = UIView().then {
        $0.backgroundColor = UIColor.fromRGB(0, 0, 0, 0.16)
        $0.layer.cornerRadius = 5
    }
    
    let firstTeamStackView = UIStackView().then {
        $0.alignment = .center
        $0.axis = .vertical
        $0.distribution = .fill
        $0.spacing = 10
    }
    
    let firstTeamLabel = UILabel().then {
        $0.text = "Red"
        $0.frame = CGRect(x: 0, y: 0,width: 39, height: 24)
        $0.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        $0.textColor = .systemRed
    }
    
    let firstTeamScoreLabel = UILabel().then {
        $0.text = "24"
        $0.font = UIFont.systemFont(ofSize: 32, weight: .semibold)
        $0.textColor = .white
        $0.textAlignment = .center
    }
    
    let firstButtonStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .fillEqually
        $0.spacing = 15
    }
    
    let secondButtonStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .fillEqually
        $0.spacing = 15
    }

    let secondTeamSpaceView = UIView().then {
        $0.backgroundColor = UIColor.fromRGB(0, 0, 0, 0.16)
        $0.layer.cornerRadius = 5
    }
    
    let secondTeamStackView = UIStackView().then {
        $0.alignment = .center
        $0.axis = .vertical
        $0.distribution = .fill
        $0.spacing = 10
    }
    
    let secondTeamLabel = UILabel().then {
        $0.text = "Blue"
        $0.frame = CGRect(x: 0, y: 0,width: 39, height: 24)
        $0.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        $0.textColor = .systemBlue
    }
    
    let secondTeamScoreLabel = UILabel().then {
        $0.text = "20"
        $0.font = UIFont.systemFont(ofSize: 32, weight: .semibold)
        $0.textColor = .white
        $0.textAlignment = .center
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.fromRGB(58, 53, 48, 1)
        view.addSubview(quarterLabel)
        view.addSubview(backgroundImage)
        view.addSubview(firstTeamSpaceView)
        firstTeamSpaceView.addSubview(firstTeamStackView)
        firstTeamStackView.addArrangedSubview(firstTeamLabel)
        firstTeamStackView.addArrangedSubview(firstTeamScoreLabel)
        firstTeamStackView.addArrangedSubview(firstButtonStackView)
        setupBtn(firstButtonStackView)

        view.addSubview(secondTeamSpaceView)
        secondTeamSpaceView.addSubview(secondTeamStackView)
        secondTeamStackView.addArrangedSubview(secondTeamLabel)
        secondTeamStackView.addArrangedSubview(secondTeamScoreLabel)
        secondTeamStackView.addArrangedSubview(secondButtonStackView)

        setupBtn(secondButtonStackView)
        layout()
    }
    private func setupBtn(_ stackView: UIStackView) {
        let backNumber = [13,15,2,3,23]
        for title in backNumber {
            let button = UIButton().then {
                $0.setTitle("\(title)", for: .normal)
                $0.backgroundColor = .white
                $0.setTitleColor(.black, for: .normal)
                $0.layer.cornerRadius = 5
                $0.layer.masksToBounds = true
                $0.snp.makeConstraints { make in
                    make.width.equalTo(50)
                    make.height.equalTo(40)
                }
            }
            stackView.addArrangedSubview(button)
        }
    }
    private func layout() {
        
        backgroundImage.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(-15)
            make.top.equalToSuperview()
        }

        quarterLabel.snp.makeConstraints { make in
            make.centerX.equalTo(backgroundImage)
            make.bottom.equalTo(backgroundImage)

        }
        
        firstTeamSpaceView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(22)
            make.top.equalTo(quarterLabel.snp.bottom).offset(70)
        }
        
        firstTeamStackView.snp.makeConstraints {make in
            make.left.right.equalTo(firstTeamSpaceView).inset(20)
            make.top.bottom.equalTo(firstTeamSpaceView).inset(15)
        }
        
        secondTeamSpaceView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(22)
            make.top.equalTo(firstTeamSpaceView.snp.bottom).offset(24)
        }
        
        secondTeamStackView.snp.makeConstraints {make in
            make.left.right.equalTo(secondTeamSpaceView).inset(20)
            make.top.bottom.equalTo(secondTeamSpaceView).inset(15)
        }
    }
}

#Preview {
    GameStatVC()
}

