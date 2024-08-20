//
//  ViewController.swift
//  UITester
//
//  Created by 양승완 on 7/4/24.
//

import UIKit
import SnapKit
import ReactorKit
import RxCocoa
import RxSwift
import Then


class BuilderVC: UIViewController, View {
   
    
    
    var disposeBag = DisposeBag()
    
    
    
    let topLine = UIView().then {
        $0.backgroundColor = .mainWhite()
    }
    
    let bottomLine = UIView().then {
        $0.backgroundColor = .mainWhite()
    }
    
    
    let homeAddIcon = UIView().then { view in
        view.backgroundColor = .customOrange()
        view.layer.cornerRadius = 15
        let plusImg = UIImageView(image: UIImage(named: "plus.png"))
        plusImg.contentMode = .scaleAspectFit
        
        view.addSubview(plusImg)

        
        plusImg.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.height.equalTo(15)
        }

        
    }
  
    let awayAddIcon = UIView().then { view in
        view.backgroundColor = .customOrange()
        view.layer.cornerRadius = 15
        let plusImg = UIImageView(image: UIImage(named: "plus.png"))
        plusImg.contentMode = .scaleAspectFit
        
        view.addSubview(plusImg)

        
        plusImg.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.height.equalTo(15)
        }

        
    }
    
    private let homeArr: [PlayerModel] = []
    private let awayArr: [PlayerModel] = []
    
    let mainLabel = UILabel().then {
        $0.font = UIFont.customBoldFont(size: 20)
        $0.textColor = .white
        $0.text = "Team Builder"
    }
    
    lazy var homeTableView = UITableView().then {
        $0.register(PlayerBuilderCell.self, forCellReuseIdentifier: "PlayerCell1")
        $0.isScrollEnabled = false
        $0.rowHeight = 50
        $0.backgroundColor = .clear
        
        $0.separatorColor = .mainWhite()
        $0.separatorStyle = .singleLine
        $0.separatorInset = .init(top: 0, left: 0, bottom: 0, right: 2)
        
        $0.delegate = self
        $0.tag = 0
        

   
    }
    let borderView = UIView().then {
        $0.backgroundColor = .mainWhite()
        $0.snp.makeConstraints { $0.width.equalTo(1) }
    }
    lazy var awayTableView = UITableView().then {
        $0.register(PlayerBuilderCell.self, forCellReuseIdentifier: "PlayerCell2")
        $0.isScrollEnabled = false
        $0.rowHeight = 50
        $0.backgroundColor = .clear
        
        $0.separatorColor = .mainWhite()
        $0.separatorStyle = .singleLine
        $0.separatorInset = .init(top: 0, left: 2, bottom: 0, right: 0)

        $0.delegate = self
        $0.tag = 1
    }
    
    let homeLogo = UIImageView(image: UIImage(named: "image1.png")).then {
        $0.layer.cornerRadius = 6
    }
    let awayLogo = UIImageView(image: UIImage(named: "image2.png")).then {
        $0.layer.cornerRadius = 6
    }
    
    let homeName = UILabel().then {
        $0.text = "Lakers"
        $0.textAlignment = .center
        $0.textColor = .mainWhite()
        $0.font = .bold_16

    }
    
    let awayName = UILabel().then {
        $0.text = "Basketball"
        $0.textAlignment = .center
        $0.textColor = .mainWhite()
        $0.font = .bold_16

    }
    
  
   
    lazy var teamPlayerStackView = UIStackView(arrangedSubviews: [self.homeTableView, self.borderView, self.awayTableView]).then {
        $0.alignment = .fill
        $0.distribution = .fillProportionally
        $0.axis = .horizontal

    }
    
    let checkBtn = UIButton().then {
        $0.setTitle("확인", for: .normal)
        
        $0.titleLabel?.textColor = .white
        $0.titleLabel?.font = .systemFont(ofSize: 14)
        $0.backgroundColor = .customOrange()
        $0.layer.cornerRadius = 4
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.view.backgroundColor = .mainColor()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUI()

       
    }
    

    let homeArrRemove = PublishSubject<Int>()
    let awayArrRemove = PublishSubject<Int>()
    
    let homeArrUpdate = PublishSubject<Int>()
    let awayArrUpdate = PublishSubject<Int>()
    
    func bind(reactor: BuilderReactor) {
        
        
        self.rx.methodInvoked(#selector(self.viewDidLoad))
                    .map { _ in Reactor.Action.viewDidLoad }
                    .bind(to: reactor.action)
                    .disposed(by: disposeBag)
        
        reactor.state.map { _ in reactor.currentState.homeArr }
            .bind(to: self.homeTableView.rx.items(
                        cellIdentifier: "PlayerCell1",
                        cellType: PlayerBuilderCell.self)
                    ) { index, item, cell in
                cell.selectionStyle = UITableViewCell.SelectionStyle.none
                cell.numberLabel.text = item.number

                cell.nameLabel.text = item.nickname
                    }.disposed(by: disposeBag)
        
        reactor.state.map { _ in reactor.currentState.awayArr }
            .bind(to: self.awayTableView.rx.items(
                        cellIdentifier: "PlayerCell2",
                        cellType: PlayerBuilderCell.self)
                    ) { index, item, cell in
                cell.selectionStyle = UITableViewCell.SelectionStyle.none
                
                cell.numberLabel.text = item.number
                cell.nameLabel.text = item.nickname
                    }.disposed(by: disposeBag)
        
        reactor.state.map { _ in reactor.currentState.pushSearchView }.subscribe(onNext: { [weak self] val in
            guard let self else {return}
            if val {
                let vc = SearchVC()
                let reactor = SearchReactor(provider: ServiceProvider(), builderReactor: self.reactor!)
                vc.reactor = reactor
                
                
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }).disposed(by: disposeBag)
        
        
        self.homeArrRemove.map { index in Reactor.Action.homeArrRemove(index) }.bind(to: reactor.action ).disposed(by: self.disposeBag)
        
        self.awayArrRemove.map { index in Reactor.Action.awayArrRemove(index) }.bind(to: reactor.action ).disposed(by: self.disposeBag)
        
        self.homeArrUpdate.map { index in Reactor.Action.homeArrUpdate(index) }.bind(to: reactor.action).disposed(by: self.disposeBag)
        
        self.awayArrUpdate.map { index in Reactor.Action.awayArrUpdate(index) }.bind(to: reactor.action).disposed(by: self.disposeBag)
        
        
        
    
         
    }
    
    
    func setUI() {
        let VIEW_WIDTH = self.view.frame.width - ( 52 * 2 )
        
        self.view.addSubview(mainLabel)
        self.view.addSubview(homeLogo)
        self.view.addSubview(awayLogo)
        self.view.addSubview(homeName)
        self.view.addSubview(awayName)
        self.view.addSubview(teamPlayerStackView)
        self.view.addSubview(checkBtn)
        self.teamPlayerStackView.addSubview(topLine)
        self.teamPlayerStackView.addSubview(bottomLine)
        
        self.homeLogo.addSubview(self.homeAddIcon)
        self.awayLogo.addSubview(self.awayAddIcon)
        
        
     
        self.homeLogo.contentMode = .scaleAspectFit
        self.awayLogo.contentMode = .scaleAspectFit
        self.homeLogo.backgroundColor = .fromRGB(217, 217, 217, 1)
        self.awayLogo.backgroundColor = .fromRGB(217, 217, 217, 1)


        self.homeLogo.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(50)
            $0.height.equalTo(120)
            $0.width.equalTo(130)
            $0.top.equalToSuperview().inset(180)
        }
        self.awayLogo.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(50)
            $0.height.equalTo(120)
            $0.width.equalTo(130)
            $0.top.equalToSuperview().inset(180)
        }
        
        self.homeName.snp.makeConstraints {
            $0.centerX.equalTo(self.homeLogo)
            $0.top.equalTo(self.homeLogo.snp.bottom)
            $0.height.equalTo(50)

        }
        self.awayName.snp.makeConstraints {
            $0.centerX.equalTo(self.awayLogo)
            $0.top.equalTo(self.awayLogo.snp.bottom)
            $0.height.equalTo(50)
        }
        
        
        self.homeTableView.snp.makeConstraints {
            
            
            $0.width.equalTo(VIEW_WIDTH / 2 - 0.5)
        }
        
        self.awayTableView.snp.makeConstraints {

            $0.width.equalTo(VIEW_WIDTH / 2 - 0.5)
        }
        self.teamPlayerStackView.snp.makeConstraints {
            $0.top.equalTo(self.awayName.snp.bottom)
            $0.leading.trailing.equalToSuperview().inset(52)
            $0.bottom.equalToSuperview().inset(260)
        }
        
        self.mainLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(120)
            $0.centerX.equalToSuperview()
        }
        
        
        self.homeAddIcon.snp.makeConstraints {
            $0.bottom.trailing.equalToSuperview().inset(6)
            $0.width.height.equalTo(30)
        }  
        self.awayAddIcon.snp.makeConstraints {
            $0.bottom.trailing.equalToSuperview().inset(6)
            $0.width.height.equalTo(30)
        }
        
        self.bottomLine.snp.makeConstraints {
            $0.width.centerX.equalToSuperview()
            $0.top.equalTo(self.teamPlayerStackView.snp.bottom)
            $0.height.equalTo(1)

        }
        
        self.topLine.snp.makeConstraints {
            $0.width.centerX.equalToSuperview()
            $0.bottom.equalTo(self.teamPlayerStackView.snp.top)
            $0.height.equalTo(1)
        }
        
        self.checkBtn.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(50)
            $0.height.equalTo(40)
            $0.width.equalTo(170)
            
        }
        
        
        
        
    }
    
    
}



extension BuilderVC: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let updateAction = UIContextualAction(style: .normal, title:  "수정", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            if tableView.tag == 0 {
                self.homeArrUpdate.onNext(indexPath.row)
            } else {
                self.awayArrUpdate.onNext(indexPath.row)
            }
            success(true)
        })
        updateAction.backgroundColor = .customOrange()
       

        return UISwipeActionsConfiguration(actions: [updateAction])
    }
    
    public func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
     
        let deleteAction = UIContextualAction(style: .normal, title:  "삭제", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            
            if tableView.tag == 0 {
                self.homeArrRemove.onNext(indexPath.row)

            } else {
                self.awayArrRemove.onNext(indexPath.row)

            }
            
            success(true)
        })
        deleteAction.backgroundColor = .customOrange()
       

        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}

