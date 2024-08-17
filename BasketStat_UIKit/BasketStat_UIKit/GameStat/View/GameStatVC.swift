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
    
    lazy var firstTeamStackView = UIStackView(arrangedSubviews: [firstTeamLabel, firstTeamScoreLabel, firstTeamPlayerStackView]).then {
        $0.backgroundColor = UIColor.fromRGB(0, 0, 0, 0.16)
        $0.layer.cornerRadius = 5
        $0.alignment = .center
        $0.axis = .vertical
        $0.spacing = 10
        $0.isLayoutMarginsRelativeArrangement = true
        $0.layoutMargins = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
    }
    
    lazy var secondTeamStackView = UIStackView(arrangedSubviews: [secondTeamLabel, secondTeamScoreLabel, secondTeamPlayerStackView]).then {
        $0.backgroundColor = UIColor.fromRGB(0, 0, 0, 0.16)
        $0.layer.cornerRadius = 5
        $0.alignment = .center
        $0.axis = .vertical
        $0.spacing = 10
        $0.isLayoutMarginsRelativeArrangement = true
        $0.layoutMargins = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
    }
    
    lazy var firstTeamPlayerStackView = UIStackView(arrangedSubviews: [player1Button, player2Button, player3Button, player4Button, player5Button]) .then {
        $0.axis = .horizontal
        $0.distribution = .fillEqually
        $0.spacing = 15
    }
    
    lazy var secondTeamPlayerStackView = UIStackView(arrangedSubviews: [player6Button, player7Button, player8Button, player9Button, player10Button]).then {
        $0.axis = .horizontal
        $0.distribution = .fillEqually
        $0.spacing = 15
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
        $0.distribution = .fill
        $0.spacing = 10
    }
    
    lazy var recordStackView = UIStackView(arrangedSubviews: [cancleButton, saveButton]).then {
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
    private lazy var toButton = UIButton.createStatButton(stat: .TwoPT)
    
    var twoPointSegmentControl: UISegmentedControl!
    var threePointSegmentControl: UISegmentedControl!
    var freeThrowPointSegmentControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        bind(reactor: reactor)
        layout()
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
    }
       
}

// MARK: Button Setup
extension GameStatVC {
    
    private func createFirstRowStack(button: UIButton, segment : UISegmentedControl) -> UIStackView {
        return UIStackView().then {
            $0.axis = .vertical
            $0.distribution = .fill
            $0.addArrangedSubview(button)
            $0.addArrangedSubview(segment)
            $0.layer.borderColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.3).cgColor
            $0.layer.borderWidth = 1
            $0.layer.cornerRadius = 5
        }
    }
    
    private func createSegmentControls() -> UISegmentedControl {
        return UISegmentedControl(items: ["성공", "실패"]).then {
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
            $0.snp.makeConstraints { make in
                make.height.equalTo(25)
            }
        }
    }
    
    private func setupButtons() {
        
        lazy var firstRowStackView = UIStackView(arrangedSubviews: [twoPointButton, threePointButton, freeThrowButton]).then {
            $0.axis = .horizontal
            $0.distribution = .fillEqually
            $0.spacing = 10
        }
        
        let secondRowStackView = UIStackView().then {
            $0.axis = .horizontal
            $0.distribution = .fillEqually
            $0.spacing = 10
        }
        
        let thirdRowStackView = UIStackView().then {
            $0.axis = .horizontal
            $0.distribution = .fillEqually
            $0.spacing = 10
        }
        
        buttonGridStackView.addArrangedSubview(firstRowStackView)
        buttonGridStackView.addArrangedSubview(secondRowStackView)
        buttonGridStackView.addArrangedSubview(thirdRowStackView)

    }
    
    private func clearHighlight(for stat: Stat) {
        switch stat {
        case .TwoPT:
            clearStackViewHighlight(for: twoPointButton)
        case .ThreePT:
            clearStackViewHighlight(for: threePointButton)
        case .FreeThrow:
            clearStackViewHighlight(for: freeThrowButton)
        case .AST:
            clearButtonHighlight(for: astButton)
        case .REB:
            clearButtonHighlight(for: rebButton)
        case .BLK:
            clearButtonHighlight(for: blkButton)
        case .STL:
            clearButtonHighlight(for: stlButton)
        case .FOUL:
            clearButtonHighlight(for: foulButton)
        case .TO:
            clearButtonHighlight(for: toButton)
        }
    }
    
    private func highlight(for stat: Stat) {
        switch stat {
        case .TwoPT:
            highlightStackView(for: twoPointButton)
        case .ThreePT:
            highlightStackView(for: threePointButton)
        case .FreeThrow:
            highlightStackView(for: freeThrowButton)
        case .AST:
            highlightButton(astButton)
        case .REB:
            highlightButton(rebButton)
        case .BLK:
            highlightButton(blkButton)
        case .STL:
            highlightButton(stlButton)
        case .FOUL:
            highlightButton(foulButton)
        case .TO:
            highlightButton(toButton)
        }
    }
    
    private func highlightStackView(for button: UIButton?) {
        guard let button = button, let stackView = button.superview as? UIStackView else { return }
        stackView.layer.borderColor = UIColor.orange.cgColor
        stackView.layer.borderWidth = 4
    }
    
    private func clearStackViewHighlight(for button: UIButton) {
        guard let stackView = button.superview as? UIStackView else { return }
        stackView.layer.borderColor = UIColor.clear.cgColor
        stackView.layer.borderWidth = 0
    }
    
    private func highlightButton(_ button: UIButton?) {
        button?.layer.borderWidth = 4
        button?.layer.borderColor = UIColor.orange.cgColor
    }
    
    private func clearButtonHighlight(for button: UIButton) {
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.3).cgColor
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
        
//        firstTeamStackView.snp.makeConstraints { make in
//            make.left.right.equalTo(firstTeamSpaceView).inset(20)
//            make.top.bottom.equalTo(firstTeamSpaceView).inset(15)
//        }
        
        secondTeamStackView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(22)
            make.top.equalTo(firstTeamStackView.snp.bottom).offset(15)
        }
        
//        secondTeamStackView.snp.makeConstraints { make in
//            make.left.right.equalTo(secondTeamSpaceView).inset(20)
//            make.top.bottom.equalTo(secondTeamSpaceView).inset(15)
//        }
//        
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
                    owner.clearHighlight(for: previousStat)
                }
                
                if let currentStat = currentStat {
                    owner.highlight(for: currentStat)
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

