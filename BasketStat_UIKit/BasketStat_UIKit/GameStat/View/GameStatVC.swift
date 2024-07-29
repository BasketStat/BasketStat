//
//  GameStatVC.swift
//  BasketStat_UIKit
//
//  Created by 김정원 on 7/16/24.
//

import UIKit
import Then
import SnapKit
import RxSwift
import ReactorKit
import RxCocoa

class GameStatVC: UIViewController, View {
    
    var disposeBag = DisposeBag()
    let reactor = GameStatReactor()
    
    let backgroundImage = UIImageView().then {
        $0.image = UIImage(named: "background")!
        $0.contentMode = .scaleAspectFill
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    let quarterLabel = UILabel().then {
        $0.text = "1Q"
        $0.frame = CGRect(x: 0, y: 0,width: 84, height: 76)
        $0.textColor = .white
        $0.font = UIFont.customBoldFont(size: 64)
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
        $0.font = UIFont.h1b
        $0.textColor = .systemRed
    }
    
    let firstTeamScoreLabel = UILabel().then {
        $0.text = "24"
        $0.font = UIFont.regular1
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
        $0.font = UIFont.h1b
        $0.textColor = .systemBlue
    }
    
    let secondTeamScoreLabel = UILabel().then {
        $0.text = "20"
        $0.font = UIFont.regular1
        $0.textColor = .white
        $0.textAlignment = .center
    }
    
    let recordLabel = UILabel().then {
        $0.text = "기록"
        $0.font = UIFont.regular4
        $0.textColor = .white
    }
    
    let buttonGridStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 10
    }
    
    let recordStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 15
        $0.distribution = .fillEqually
    }
    
    let cancleButton = UIButton().then {
        $0.setTitle("X", for: .normal)
        $0.titleLabel?.font = UIFont.customFont(fontName: "Pretendard-Black", size: 14)
        $0.backgroundColor = .clear
        $0.setTitleColor(.white, for: .normal)
        $0.layer.cornerRadius = 5
        $0.layer.borderColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.3).cgColor
        $0.layer.borderWidth = 1
        $0.layer.masksToBounds = true
    }
    
    let saveButton = UIButton().then {
        $0.setTitle("O", for: .normal)
        $0.titleLabel?.font = UIFont.customFont(fontName: "Pretendard-Black", size: 14)
        $0.setTitleColor(.white, for: .normal)
        $0.layer.cornerRadius = 5
        $0.backgroundColor = UIColor.fromRGB(255, 107, 0, 0.9)
        $0.layer.masksToBounds = true

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind(reactor: reactor)
        view.backgroundColor = UIColor.mainColor()
        view.addSubview(backgroundImage)
        view.addSubview(quarterLabel)
        view.addSubview(firstTeamSpaceView)
        view.addSubview(recordLabel)
        view.addSubview(secondTeamSpaceView)
        view.addSubview(buttonGridStackView)
        view.addSubview(recordStackView)
        
        firstTeamSpaceView.addSubview(firstTeamStackView)
        firstTeamStackView.addArrangedSubview(firstTeamLabel)
        firstTeamStackView.addArrangedSubview(firstTeamScoreLabel)
        firstTeamStackView.addArrangedSubview(firstButtonStackView)
        setupBtn(firstButtonStackView)
        
        secondTeamSpaceView.addSubview(secondTeamStackView)
        secondTeamStackView.addArrangedSubview(secondTeamLabel)
        secondTeamStackView.addArrangedSubview(secondTeamScoreLabel)
        secondTeamStackView.addArrangedSubview(secondButtonStackView)
        
        setupBtn(secondButtonStackView)
        setupButtonGrid()
        
        recordStackView.addArrangedSubview(cancleButton)
        recordStackView.addArrangedSubview(saveButton)
        
        layout()
    }
    
    private func setupBtn(_ stackView: UIStackView) {
        let backNumber = [13, 15, 2, 3, 23]
        for number in backNumber {
            let button = UIButton().then {
                $0.setTitle("\(number)", for: .normal)
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
            button.rx.tap
                .map { Reactor.Action.selectedPlayer(number: number, button: button) }
                .bind(to: reactor.action)
                .disposed(by: disposeBag)
            stackView.addArrangedSubview(button)
        }
    }
    
    private func setupButtonGrid() {
        // 첫 번째 줄 버튼과 세그먼트 컨트롤 추가
        let firstRowStackView = UIStackView().then {
            $0.axis = .horizontal
            $0.distribution = .fillEqually
            $0.spacing = 15
        }
        
        let firstRowItems = [
            ("2점슛", ["성공", "실패"]),
            ("3점슛", ["성공", "실패"]),
            ("자유투", ["성공", "실패"])
        ]
        
        for (title, segments) in firstRowItems {
            let buttonStack = UIStackView().then {
                $0.axis = .vertical
                $0.layer.cornerRadius = 5
                $0.layer.borderWidth = 1
                $0.layer.borderColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.3).cgColor
            }
            
            let button = UIButton().then {
                $0.setTitle(title, for: .normal)
                $0.titleLabel?.font = UIFont.boldButton
                $0.backgroundColor = .clear
                $0.setTitleColor(.white, for: .normal)
                $0.layer.cornerRadius = 5
                $0.layer.masksToBounds = true
                $0.snp.makeConstraints { make in
                    make.height.equalTo(40)
                }
            }
            buttonStack.addArrangedSubview(button)
            
            let segmentControl = UISegmentedControl(items: segments).then {
                $0.selectedSegmentIndex = 0
                let normalTextAttributes: [NSAttributedString.Key: Any] = [
                       .foregroundColor: UIColor.lightGray,
                       .font: UIFont.regularButton
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
            }
            buttonStack.addArrangedSubview(segmentControl)
            
            firstRowStackView.addArrangedSubview(buttonStack)
        }
        buttonGridStackView.addArrangedSubview(firstRowStackView)
        
        // 나머지 줄 버튼 추가
        let otherRowsItems = [
            [Stat.AST, Stat.REB, Stat.BLK],
            [Stat.STL, Stat.FOUL, Stat.TO]
        ]
        
        for row in otherRowsItems {
            let rowStackView = UIStackView().then {
                $0.axis = .horizontal
                $0.distribution = .fillEqually
                $0.spacing = 15
            }
            
            for title in row {
                let button = UIButton().then {
                    $0.setTitle(title.rawValue, for: .normal)
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
                rowStackView.addArrangedSubview(button)
            }
            
            buttonGridStackView.addArrangedSubview(rowStackView)
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
            make.top.equalTo(quarterLabel.snp.bottom).offset(60)
        }
        
        firstTeamStackView.snp.makeConstraints { make in
            make.left.right.equalTo(firstTeamSpaceView).inset(20)
            make.top.bottom.equalTo(firstTeamSpaceView).inset(15)
        }
        
        secondTeamSpaceView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(22)
            make.top.equalTo(firstTeamSpaceView.snp.bottom).offset(15)
        }
        
        secondTeamStackView.snp.makeConstraints { make in
            make.left.right.equalTo(secondTeamSpaceView).inset(20)
            make.top.bottom.equalTo(secondTeamSpaceView).inset(15)
        }
        
        recordLabel.snp.makeConstraints { make in
            make.left.equalTo(secondTeamSpaceView.snp.left)
            make.top.equalTo(secondTeamSpaceView.snp.bottom).offset(15)
        }
        
        buttonGridStackView.snp.makeConstraints { make in
            make.left.right.equalTo(secondTeamSpaceView)
            make.top.equalTo(recordLabel.snp.bottom).offset(10)
        }
        
        recordStackView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(buttonGridStackView.snp.horizontalEdges)
            make.top.equalTo(buttonGridStackView.snp.bottom).offset(15)
            make.height.equalTo(40)
        }
        
    }
}
extension GameStatVC {
    
    func bind(reactor: GameStatReactor) {
        // 이전에 선택된 버튼과 새로운 선택된 버튼을 구독
        reactor.state.map { $0.previousSelectedPlayerButton }
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] previousSelectedButton in
                guard self != nil else { return }
                previousSelectedButton?.layer.borderWidth = 0
                previousSelectedButton?.layer.borderColor = UIColor.clear.cgColor
            })
            .disposed(by: disposeBag)
        
        // 새로운 선택된 버튼에 스트로크 추가
        reactor.state.map { $0.playerButtons }
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] selectedButton in
                guard self != nil else { return }
                selectedButton?.layer.borderWidth = 4
                selectedButton?.layer.borderColor = UIColor.orange.cgColor // RGB 변경
            })
            .disposed(by: disposeBag)
    }
}
//#Preview {
//    GameStatVC()
//}
//
