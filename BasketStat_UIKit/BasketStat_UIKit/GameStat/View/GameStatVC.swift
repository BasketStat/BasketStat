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
    
    private let backgroundImage = UIImageView().then {
        $0.image = UIImage(named: "background")!
        $0.contentMode = .scaleAspectFill
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private let quarterLabel = UILabel().then {
        $0.text = "1Q"
        $0.frame = CGRect(x: 0, y: 0,width: 84, height: 76)
        $0.textColor = .white
        $0.font = UIFont.customBoldFont(size: 64)
    }
    
    private let firstTeamLabel = UILabel().then {
        $0.text = "Red"
        $0.frame = CGRect(x: 0, y: 0,width: 39, height: 24)
        $0.font = UIFont.h1b
        $0.textColor = .systemRed
    }
    
    private let firstTeamScoreLabel = UILabel().then {
        $0.text = "24"
        $0.font = UIFont.regular1
        $0.textColor = .white
        $0.textAlignment = .center
    }
    
    private lazy var firstTeamStackView = UIStackView(arrangedSubviews: [firstTeamLabel, firstTeamScoreLabel, firstTeamPlayerStackView]).then {
        $0.backgroundColor = UIColor.fromRGB(0, 0, 0, 0.16)
        $0.layer.cornerRadius = 5
        $0.alignment = .center
        $0.axis = .vertical
        $0.spacing = 10
        $0.isLayoutMarginsRelativeArrangement = true
        $0.layoutMargins = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
    }
    
    private lazy var secondTeamStackView = UIStackView(arrangedSubviews: [secondTeamLabel, secondTeamScoreLabel, secondTeamPlayerStackView]).then {
        $0.backgroundColor = UIColor.fromRGB(0, 0, 0, 0.16)
        $0.layer.cornerRadius = 5
        $0.alignment = .center
        $0.axis = .vertical
        $0.spacing = 10
        $0.isLayoutMarginsRelativeArrangement = true
        $0.layoutMargins = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
    }
    
    private lazy var firstTeamPlayerStackView = UIStackView(arrangedSubviews: [player1Button, player2Button, player3Button, player4Button, player5Button]) .then {
        $0.axis = .horizontal
        $0.spacing = 15
    }
    
    private lazy var secondTeamPlayerStackView = UIStackView(arrangedSubviews: [player6Button, player7Button, player8Button, player9Button, player10Button]).then {
        $0.axis = .horizontal
        $0.spacing = 15
    }
    
    private let secondTeamLabel = UILabel().then {
        $0.text = "Blue"
        $0.frame = CGRect(x: 0, y: 0,width: 39, height: 24)
        $0.font = UIFont.h1b
        $0.textColor = .systemBlue
    }
    
    private let secondTeamScoreLabel = UILabel().then {
        $0.text = "20"
        $0.font = UIFont.regular1
        $0.textColor = .white
        $0.textAlignment = .center
    }
    
    private let recordLabel = UILabel().then {
        $0.text = "기록"
        $0.font = UIFont.regular4
        $0.textColor = .white
    }
    
    private let buttonGridStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 10
    }
    
    private lazy var recordStackView = UIStackView(arrangedSubviews: [cancleButton, saveButton]).then {
        $0.axis = .horizontal
        $0.spacing = 15
        $0.distribution = .fillEqually
    }
    
    private let cancleButton = UIButton().then {
        $0.setTitle("X", for: .normal)
        $0.titleLabel?.font = UIFont.customFont(fontName: "Pretendard-Black", size: 14)
        $0.backgroundColor = .clear
        $0.setTitleColor(.white, for: .normal)
        $0.layer.cornerRadius = 5
        $0.layer.borderColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.3).cgColor
        $0.layer.borderWidth = 1
        $0.layer.masksToBounds = true
    }
    
    private let saveButton = UIButton().then {
        $0.setTitle("O", for: .normal)
        $0.titleLabel?.font = UIFont.customFont(fontName: "Pretendard-Black", size: 14)
        $0.setTitleColor(.white, for: .normal)
        $0.layer.cornerRadius = 5
        $0.backgroundColor = UIColor.fromRGB(255, 107, 0, 0.9)
        $0.layer.masksToBounds = true
        
    }
    var playersButton: [UIButton] = []
    
    private lazy var player1Button = UIButton.createPlayerButton(backNumber: 10)
    private lazy var player2Button = UIButton.createPlayerButton(backNumber: 14)
    private lazy var player3Button = UIButton.createPlayerButton(backNumber: 13)
    private lazy var player4Button = UIButton.createPlayerButton(backNumber: 16)
    private lazy var player5Button = UIButton.createPlayerButton(backNumber: 13)
    private lazy var player6Button = UIButton.createPlayerButton(backNumber: 45)
    private lazy var player7Button = UIButton.createPlayerButton(backNumber: 5)
    private lazy var player8Button = UIButton.createPlayerButton(backNumber: 18)
    private lazy var player9Button = UIButton.createPlayerButton(backNumber: 9)
    private lazy var player10Button = UIButton.createPlayerButton(backNumber: 14)
    private lazy var twoPointButton = UIButton.createStatButton(stat: .TwoPT)
    private lazy var threePointButton = UIButton.createStatButton(stat: .ThreePT)
    private lazy var freeThrowButton = UIButton.createStatButton(stat: .FreeThrow)
    private lazy var astButton = UIButton.createStatButton(stat: .AST)
    private lazy var rebButton = UIButton.createStatButton(stat: .REB)
    private lazy var blkButton = UIButton.createStatButton(stat: .BLK)
    private lazy var stlButton = UIButton.createStatButton(stat: .STL)
    private lazy var foulButton = UIButton.createStatButton(stat: .FOUL)
    private lazy var toButton = UIButton.createStatButton(stat: .TO)
    
    private lazy var twoPointSegmentControl = UISegmentedControl.createSegmentControls()
    private lazy var threePointSegmentControl = UISegmentedControl.createSegmentControls()
    private lazy var freeThrowPointSegmentControl = UISegmentedControl.createSegmentControls()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        bind(reactor: reactor)
    }
}
// MARK: View Setup
extension GameStatVC {
    
    private func setupView() {
        
        view.backgroundColor = UIColor.mainColor()
        view.addSubview(backgroundImage)
        view.addSubview(quarterLabel)
        view.addSubview(firstTeamStackView)
        view.addSubview(secondTeamStackView)
        view.addSubview(recordLabel)
        view.addSubview(buttonGridStackView)
        view.addSubview(recordStackView)
        setupButtons()
        layout()

    }
    
    private func setupButtons() {
        lazy var pointStackView = UIStackView(arrangedSubviews: [twoPointButton, twoPointSegmentControl]).then {
            $0.axis = .vertical
            $0.distribution = .fill
            $0.layer.borderColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.3).cgColor
            $0.layer.borderWidth = 1
            $0.layer.cornerRadius = 5
        }
        
        lazy var point3StackView = UIStackView(arrangedSubviews: [threePointButton, threePointSegmentControl]).then {
            $0.axis = .vertical
            $0.distribution = .fill
            $0.layer.borderColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.3).cgColor
            $0.layer.borderWidth = 1
            $0.layer.cornerRadius = 5
        }
        
        lazy var freeThrowStackView = UIStackView(arrangedSubviews: [freeThrowButton, freeThrowPointSegmentControl]).then {
            $0.axis = .vertical
            $0.distribution = .fill
            $0.layer.borderColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.3).cgColor
            $0.layer.borderWidth = 1
            $0.layer.cornerRadius = 5
        }
        
        lazy var firstRowStackView = UIStackView(arrangedSubviews: [pointStackView, point3StackView, freeThrowStackView]).then {
            $0.axis = .horizontal
            $0.distribution = .fillEqually
            $0.spacing = 10
        }
        
        lazy var secondRowStackView = UIStackView(arrangedSubviews: [astButton, rebButton, blkButton]).then {
            $0.axis = .horizontal
            $0.distribution = .fillEqually
            $0.spacing = 10
        }
        
        lazy var thirdRowStackView = UIStackView(arrangedSubviews: [stlButton, foulButton, toButton]).then {
            $0.axis = .horizontal
            $0.distribution = .fillEqually
            $0.spacing = 10
        }
        
        buttonGridStackView.addArrangedSubview(firstRowStackView)
        buttonGridStackView.addArrangedSubview(secondRowStackView)
        buttonGridStackView.addArrangedSubview(thirdRowStackView)

    }
       
}

// MARK: Button Highlight 
extension GameStatVC {
    
    private func button(for stat: Stat) -> UIButton? {
        switch stat {
        case .TwoPT:
            return twoPointButton
        case .ThreePT:
            return threePointButton
        case .FreeThrow:
            return freeThrowButton
        case .AST:
            return astButton
        case .REB:
            return rebButton
        case .BLK:
            return blkButton
        case .STL:
            return stlButton
        case .FOUL:
            return foulButton
        case .TO:
            return toButton
        }
    }

    private func clearHighlightButton(for stat: Stat) {
        if let button = button(for: stat) {
            if stat == .TwoPT || stat == .ThreePT || stat == .FreeThrow {
                UIStackView.clearStackViewHighlight(for: button)
            } else {
                UIButton.clearButtonHighlight(for: button)
            }
        }
    }

    private func highlightButton(for stat: Stat) {
        if let button = button(for: stat) {
            if stat == .TwoPT || stat == .ThreePT || stat == .FreeThrow {
                UIStackView.highlightStackView(for: button)
            } else {
                UIButton.highlightButton(button)
            }
        }
    }

    private func updateButton(_ button: (UIButton?, UIButton?)) {
        button.0?.layer.borderWidth = 1
        button.0?.layer.borderColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.3).cgColor
        button.1?.layer.borderWidth = 4
        button.1?.layer.borderColor = UIColor.orange.cgColor // RGB 변경
    }
}
//MARK: Layout
extension GameStatVC {
    
    private func layout() {
        backgroundImage.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(-15)
            make.top.equalToSuperview()
        }
        
        quarterLabel.snp.makeConstraints { make in
            make.centerX.equalTo(backgroundImage)
            make.bottom.equalTo(backgroundImage)
        }
        
        firstTeamStackView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(22)
            make.top.equalTo(quarterLabel.snp.bottom).offset(60)
        }
        
        secondTeamStackView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(22)
            make.top.equalTo(firstTeamStackView.snp.bottom).offset(15)
        }
        
        recordLabel.snp.makeConstraints { make in
            make.left.equalTo(secondTeamStackView.snp.left)
            make.top.equalTo(secondTeamStackView.snp.bottom).offset(15)
        }
        
        buttonGridStackView.snp.makeConstraints { make in
            make.left.right.equalTo(secondTeamStackView)
            make.top.equalTo(recordLabel.snp.bottom).offset(10)
        }
        
        recordStackView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(buttonGridStackView.snp.horizontalEdges)
            make.top.equalTo(buttonGridStackView.snp.bottom).offset(10)
            make.height.equalTo(40)
        }
    }
}

//MARK: Reactor
extension GameStatVC {
    
    func bind(reactor: GameStatReactor) {
        // MARK: Action
        twoPointButton.rx.tap
            .map { Reactor.Action.selectedStat(stat: .TwoPT)}
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        threePointButton.rx.tap
            .map { Reactor.Action.selectedStat(stat: .ThreePT) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        freeThrowButton.rx.tap
            .map { Reactor.Action.selectedStat(stat: .FreeThrow)}
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        astButton.rx.tap
            .map { Reactor.Action.selectedStat(stat: .AST)}
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        rebButton.rx.tap
            .map {Reactor.Action.selectedStat(stat: .REB)}
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        blkButton.rx.tap
            .map {Reactor.Action.selectedStat(stat: .BLK)}
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        stlButton.rx.tap
            .map {Reactor.Action.selectedStat(stat: .STL)}
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        foulButton.rx.tap
            .map { Reactor.Action.selectedStat(stat: .FOUL)}
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        toButton.rx.tap
            .map { Reactor.Action.selectedStat(stat: .TO) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    
        
        cancleButton.rx.tap
            .map{Reactor.Action.selectedCancleButton}
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // MARK: State
        reactor.state.map { $0.currentStat }
            .distinctUntilChanged()
            .subscribe(with: self) { owner, currentStat in
                if let previousStat = reactor.currentState.previousStat {
                    owner.clearHighlightButton(for: previousStat)
                }
                
                if let currentStat = currentStat {
                    owner.highlightButton(for: currentStat)
                }
            }
            .disposed(by: disposeBag)
        
        Observable.combineLatest(
            reactor.state.map {$0.playerButton.0}.distinctUntilChanged(),
            reactor.state.map {$0.playerButton.1}.distinctUntilChanged()
        ) .subscribe(onNext: { [weak self] preButton, newButton in
            guard let vc = self else { return }
            vc.updateButton((preButton, newButton))
        })
        .disposed(by: disposeBag)

    }
}

#Preview {
    GameStatVC()
}

