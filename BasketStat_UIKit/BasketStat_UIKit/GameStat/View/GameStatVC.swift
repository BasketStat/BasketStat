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
    
    var firstButtonStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .fillEqually
        $0.spacing = 15
    }
    
    var secondButtonStackView = UIStackView().then {
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
        $0.distribution = .fill
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
    var playersButton: [UIButton] = []
    var twoPointButton: UIButton!
    var threePointButton: UIButton!
    var freeThrowButton: UIButton!
    var astButton: UIButton!
    var rebButton: UIButton!
    var blkButton: UIButton!
    var stlButton: UIButton!
    var foulButton: UIButton!
    var toButton: UIButton!
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
        view.addSubview(firstTeamSpaceView)
        view.addSubview(recordLabel)
        view.addSubview(secondTeamSpaceView)
        view.addSubview(buttonGridStackView)
        view.addSubview(recordStackView)
        
        firstTeamSpaceView.addSubview(firstTeamStackView)
        firstTeamStackView.addArrangedSubview(firstTeamLabel)
        firstTeamStackView.addArrangedSubview(firstTeamScoreLabel)
        firstTeamStackView.addArrangedSubview(firstButtonStackView)
        
        secondTeamSpaceView.addSubview(secondTeamStackView)
        secondTeamStackView.addArrangedSubview(secondTeamLabel)
        secondTeamStackView.addArrangedSubview(secondTeamScoreLabel)
        secondTeamStackView.addArrangedSubview(secondButtonStackView)
                
        setupButtons()
        
        recordStackView.addArrangedSubview(cancleButton)
        recordStackView.addArrangedSubview(saveButton)
    }
       
}

// MARK: Button Setup
extension GameStatVC {
    
    private func createPlayerButton(backNumber: [Int]) -> UIStackView {
       
        let stackView = UIStackView().then {
            $0.axis = .horizontal
            $0.distribution = .fillEqually
            $0.spacing = 15
        }
        
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
        return stackView
    }
    
    private func updatePlayerStackView(backNumber: [Int]) {
        for (index,number) in backNumber.enumerated() {
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
            if index < 5 {
                firstButtonStackView.addArrangedSubview(button)
            }
            playersButton.append(button)
        }
    }
    
    private func createTeamStack() {
        firstTeamStackView.addArrangedSubview(createPlayerButton(backNumber: GamePlayerManager().a_TeamPlayerNumber))
        
        secondTeamStackView.addArrangedSubview(createPlayerButton(backNumber: GamePlayerManager().b_TeamPlayerNumber))
    }
    
    func createButton(stat: Stat) -> UIButton {
        
        let button = UIButton().then {
            $0.setTitle(stat.rawValue, for: .normal)
            $0.titleLabel?.font = UIFont.boldButton
            $0.backgroundColor = .clear
            $0.setTitleColor(.white, for: .normal)
            $0.layer.cornerRadius = 5
            $0.layer.borderColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.3).cgColor
            $0.layer.borderWidth = 1
            $0.layer.masksToBounds = true
            
            $0.snp.makeConstraints { make in
                make.width.equalTo(50)
                make.height.equalTo(40)
            }
        }
//        button.rx.tap
//            .map { Reactor.Action.selectedStat(stat: stat, button: button) }
//            .bind(to: reactor.action)
//            .disposed(by: disposeBag)
        
        return button
    }
    
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
        
        let firstRowStackView = UIStackView().then {
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

        twoPointButton = createButton(stat: .TwoPT)
        threePointButton = createButton(stat: .ThreePT)
        freeThrowButton = createButton(stat: .FreeThrow)
        astButton = createButton(stat: .AST)
        rebButton = createButton(stat: .REB)
        blkButton = createButton(stat: .BLK)
        stlButton = createButton(stat: .STL)
        foulButton = createButton(stat: .FOUL)
        toButton = createButton(stat: .TO)
        
        for (index, button) in [twoPointButton, threePointButton, freeThrowButton, astButton, rebButton, blkButton, stlButton, foulButton, toButton].enumerated() {
            if index < 3 {
               let stackView = createFirstRowStack(button: button!, segment: createSegmentControls())
                firstRowStackView.addArrangedSubview(stackView)
                continue
            }
            if index < 6 {
                secondRowStackView.addArrangedSubview(button!)
                continue
            }
            thirdRowStackView.addArrangedSubview(button!)
        }
        createTeamStack()
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
//        
//        Observable.combineLatest(
//            reactor.state.map {$0.pointButton.0}.distinctUntilChanged(),
//            reactor.state.map {$0.pointButton.1}.distinctUntilChanged()
//        ) .subscribe(onNext: { [weak self] preButton, newButton in
//            guard let vc = self else { return }
//            vc.updateButton((preButton, newButton))
//        })
//        .disposed(by: disposeBag)
//        
//        Observable.combineLatest(
//            reactor.state.map {$0.statButton.0}.distinctUntilChanged(),
//            reactor.state.map {$0.statButton.1}.distinctUntilChanged()
//        ) .subscribe(onNext: { [weak self] preButton, newButton in
//            guard let vc = self else { return }
//            vc.updateButton((preButton, newButton))
//        })
//        .disposed(by: disposeBag)
    }
}

//#Preview {
//    GameStatVC()
//}

