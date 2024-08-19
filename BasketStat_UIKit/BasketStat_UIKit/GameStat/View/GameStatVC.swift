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
    
    private lazy var firstTeamScoreLabel = UILabel().then {
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
    
    private lazy var firstTeamPlayerStackView = UIStackView(arrangedSubviews: aTeamButtons) .then {
        $0.axis = .horizontal
        $0.spacing = 15
    }
    
    private lazy var secondTeamPlayerStackView = UIStackView(arrangedSubviews: bTeamButtons).then {
        $0.axis = .horizontal
        $0.spacing = 15
    }
    
    private lazy var secondTeamLabel = UILabel().then {
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
        $0.titleLabel?.font = UIFont.black1
        $0.backgroundColor = .clear
        $0.setTitleColor(.white, for: .normal)
        $0.layer.cornerRadius = 5
        $0.layer.borderColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.3).cgColor
        $0.layer.borderWidth = 1
        $0.layer.masksToBounds = true
    }
    
    private let saveButton = UIButton().then {
        $0.setTitle("O", for: .normal)
        $0.titleLabel?.font = UIFont.black1
        $0.setTitleColor(.white, for: .normal)
        $0.layer.cornerRadius = 5
        $0.backgroundColor = UIColor.fromRGB(255, 107, 0, 0.9)
        $0.layer.masksToBounds = true
        
    }
    var playersButton: [UIButton] = []
    
    private lazy var aTeamButtons: [UIButton] = createTeamPlayerButtons(for: .A)
    private lazy var bTeamButtons: [UIButton] = createTeamPlayerButtons(for: .B)

    private lazy var twoPointButton = UIButton.createStatButton(stat: .TwoPT)
    private lazy var threePointButton = UIButton.createStatButton(stat: .ThreePT)
    private lazy var freeThrowButton = UIButton.createStatButton(stat: .FreeThrow)
    private lazy var astButton = UIButton.createStatButton(stat: .AST)
    private lazy var rebButton = UIButton.createStatButton(stat: .REB)
    private lazy var blkButton = UIButton.createStatButton(stat: .BLK)
    private lazy var stlButton = UIButton.createStatButton(stat: .STL)
    private lazy var foulButton = UIButton.createStatButton(stat: .FOUL)
    private lazy var toButton = UIButton.createStatButton(stat: .Turnover)
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
        lazy var point2StackView: UIView = {
            let backgroundView = UIView()
            backgroundView.layer.borderColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.3).cgColor
            backgroundView.layer.borderWidth = 1
            backgroundView.layer.cornerRadius = 5
            backgroundView.layer.masksToBounds = true
            
            let stackView = UIStackView(arrangedSubviews: [twoPointButton, twoPointSegmentControl])
            stackView.axis = .vertical
            stackView.distribution = .fill
            
            backgroundView.addSubview(stackView)
            stackView.snp.makeConstraints { make in
                make.edges.equalToSuperview().inset(0)
            }
            
            return backgroundView
        }()

        lazy var point3StackView: UIView = {
            let backgroundView = UIView()
            backgroundView.layer.borderColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.3).cgColor
            backgroundView.layer.borderWidth = 1
            backgroundView.layer.cornerRadius = 5
            backgroundView.layer.masksToBounds = true
            
            let stackView = UIStackView(arrangedSubviews: [threePointButton, threePointSegmentControl])
            stackView.axis = .vertical
            stackView.distribution = .fill
            
            backgroundView.addSubview(stackView)
            stackView.snp.makeConstraints { make in
                make.edges.equalToSuperview().inset(0)
            }
            
            return backgroundView
        }()

        lazy var freeThrowStackView: UIView = {
            let backgroundView = UIView()
            backgroundView.layer.borderColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.3).cgColor
            backgroundView.layer.borderWidth = 1
            backgroundView.layer.cornerRadius = 5
            backgroundView.layer.masksToBounds = true
            
            let stackView = UIStackView(arrangedSubviews: [freeThrowButton, freeThrowPointSegmentControl])
            stackView.axis = .vertical
            stackView.distribution = .fill
            
            backgroundView.addSubview(stackView)
            stackView.snp.makeConstraints { make in
                make.edges.equalToSuperview().inset(0)
            }
            
            return backgroundView
        }()
        
        lazy var firstRowStackView = UIStackView(arrangedSubviews: [point2StackView, point3StackView, freeThrowStackView]).then {
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
    
    private func createTeamPlayerButtons(for team: TeamType) -> [UIButton] {
        return GamePlayerManager.shared.gamePlayers
            .filter { $0.team == team }
            .map { GamePlayerManager.shared.createPlayerButton(for: $0) }
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
        case .Turnover:
            return toButton
        }
    }
    
    private func playerButton(for player: Player) -> UIButton? {
        if let index = GamePlayerManager.shared.getPlayerIndex(for: player.team, player: player) {
            return player.team == .A ? aTeamButtons[index] : bTeamButtons[index]
        }
        return nil
    }
    
    private func highlightPlayerButton(for player: Player) {
        if let button = playerButton(for: player) {
            UIButton.highlightButton(button)
        }
    }

    private func clearHighlightPlayerButton(for player: Player) {
        if let button = playerButton(for: player) {
            UIButton.clearButtonHighlight(for: button)
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
    
    private func clearHighlightButton(for stat: Stat) {
        if let button = button(for: stat) {
            if stat == .TwoPT || stat == .ThreePT || stat == .FreeThrow {
                UIStackView.clearStackViewHighlight(for: button)
            } else {
                UIButton.clearButtonHighlight(for: button)
            }
        }
    }
    
    private func clearAllHighlights() {
        for stat in Stat.allCases {
            clearHighlightButton(for: stat)
        }
        
        for button in aTeamButtons + bTeamButtons {
            UIButton.clearButtonHighlight(for: button)
        }
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
        for (index, button) in aTeamButtons.enumerated() {
            button.rx.tap
                .map { Reactor.Action.selectedPlayer(player: GamePlayerManager.shared.getPlayer(for: .A, index: index)) }
                .bind(to: reactor.action)
                .disposed(by: disposeBag)
        }
        
        // B팀 플레이어 버튼 탭 이벤트 처리
        for (index, button) in bTeamButtons.enumerated() {
            button.rx.tap
                .map { Reactor.Action.selectedPlayer(player: GamePlayerManager.shared.getPlayer(for: .B, index: index)) }
                .bind(to: reactor.action)
                .disposed(by: disposeBag)
        }

        let statButtons = [
            twoPointButton: Stat.TwoPT,
            threePointButton: Stat.ThreePT,
            freeThrowButton: Stat.FreeThrow,
            astButton: Stat.AST,
            rebButton: Stat.REB,
            blkButton: Stat.BLK,
            stlButton: Stat.STL,
            foulButton: Stat.FOUL,
            toButton: Stat.Turnover
        ]
        
        statButtons.forEach { button, stat in
            button.rx.tap
                .map { Reactor.Action.selectedStat(stat: stat) } // Stat 타입 전달
                .bind(to: reactor.action)
                .disposed(by: disposeBag)
        }
        
        cancleButton.rx.tap
            .map { Reactor.Action.selectedCancleButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        saveButton.rx.tap
            .map { Reactor.Action.selecedSaveButton }
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
                                                     
        reactor.state.map { $0.currentPlayer }
            .distinctUntilChanged()
            .subscribe(with: self) { owner, currentPlayer in
                if let previousPlayer = reactor.currentState.previousPlayer {
                    owner.clearHighlightPlayerButton(for: previousPlayer)
                }
                if let currentPlayer = currentPlayer {
                    owner.highlightPlayerButton(for: currentPlayer)
                }
            }
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.currentPlayer == nil && $0.currentStat == nil }
            .distinctUntilChanged()
            .filter { $0 }
            .subscribe(with: self) { owner, _ in
                owner.clearAllHighlights()
            }
            .disposed(by: disposeBag)
    }
}

#Preview {
    GameStatVC()
}

