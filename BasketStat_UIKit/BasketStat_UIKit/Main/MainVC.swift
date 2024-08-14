//
//  MainVC.swift
//  BasketStat_UIKit
//
//  Created by 양승완 on 8/2/24.
//

import Foundation
import UIKit
import Then
import SnapKit
import RxSwift
import ReactorKit

class MainVC: UIViewController, View {
    
    private let reactor = MainReactor(provider: ServiceProvider())
    var disposeBag = DisposeBag()
    
    
    let mainLoginImage = UIImageView(image: UIImage(named: "mainIcon.png"))

    let mainView = UIView().then {
        $0.backgroundColor = .mainColor()
    }
    
    
    var buildingBtnView = UIView().then { view in
        
        view.backgroundColor = .clear
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor.white.withAlphaComponent(0.2).cgColor
        view.layer.cornerRadius = 4
        
        let label = UILabel().then {
            $0.text = "팀빌딩"
            $0.textColor = .white
            $0.textAlignment = .center
            $0.font = .boldSystemFont(ofSize: 18 )
        }
        

        view.addSubview(label)
        
        label.snp.makeConstraints {
            $0.center.equalTo(view)
        }
       
        
    }
    
    var recordBtnView = UIView().then { view in
        
        view.backgroundColor = .clear
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor.white.withAlphaComponent(0.2).cgColor
        view.layer.cornerRadius = 4

        
        let label = UILabel().then {
            $0.text = "내 기록"
            $0.textColor = .white
            $0.textAlignment = .center
            $0.font = .boldSystemFont(ofSize: 18 )
        }
        

        view.addSubview(label)
        
        label.snp.makeConstraints {
            $0.center.equalTo(view)
        }
    }
    
    var settingBtnView = UIView().then { view in
        
        view.backgroundColor = .clear
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor.white.withAlphaComponent(0.2).cgColor
        view.layer.cornerRadius = 4

        
        
        let label = UILabel().then {
            $0.text = "설정"
            $0.textColor = .white
            $0.textAlignment = .center
            $0.font = .boldSystemFont(ofSize: 18 )
        }
        
        view.addSubview(label)
        
        label.snp.makeConstraints {
            $0.center.equalTo(view)
        }
        
    }
    
    lazy var mainStackView = UIStackView(arrangedSubviews: [buildingBtnView, recordBtnView, settingBtnView]).then {
        
        $0.axis = .vertical
        $0.spacing = 14
        $0.distribution = .fillEqually
        $0.alignment = .fill

    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUI()
        self.bind(reactor: self.reactor)

    }
    
    func bind(reactor: MainReactor) {
        
        self.settingBtnView.rx.tapGesture().when(.recognized).map { _ in Reactor.Action.settingPush }.bind(to: reactor.action).disposed(by: self.disposeBag)
        
        self.recordBtnView.rx.tapGesture().when(.recognized).map { _ in Reactor.Action.recordPush }.bind(to: reactor.action).disposed(by: disposeBag)
        
        self.buildingBtnView.rx.tapGesture().when(.recognized).map { _ in Reactor.Action.buildingPush }.bind(to: reactor.action).disposed(by: disposeBag)

        self.reactor.state.map { $0.settingPush }.distinctUntilChanged().bind { val in
            if val {
                self.navigationController?.viewControllers = [LoginVC()]
            }
            
            
        }.disposed(by: disposeBag)
        
        self.reactor.state.map { $0.buildingPush }.distinctUntilChanged().bind {val in
            if val {
                
                self.navigationController?.pushViewController(GameStatVC(), animated: false)
            }
            
        }.disposed(by: disposeBag)
        
        self.reactor.state.map { $0.recordPush }.distinctUntilChanged().bind {val in
            if val {
                print("recordPush")
//                self.navigationController?.viewControllers = [GameStatVC()]
            }
            
        }.disposed(by: disposeBag)
        
    
           
                                                              
                                                              
                                                              
                                                              
                                                              
    }

    func setUI() {
        let HEIGHT: CGFloat = 40
        let SPACING: CGFloat = 16
        
     
        self.view.addSubview(mainView)
        self.view.addSubview(mainLoginImage)
        self.view.addSubview(mainStackView)
        
        
        self.mainView.snp.makeConstraints {
            $0.top.bottom.trailing.leading.equalToSuperview()
        }
        self.mainLoginImage.snp.makeConstraints {
            $0.width.height.equalTo(310)
            $0.top.equalTo(self.view.safeAreaLayoutGuide).offset(102)
            $0.centerX.equalToSuperview()
        }
        self.mainStackView.snp.makeConstraints {
            $0.height.equalTo( HEIGHT * 3 + ( SPACING * ( 3 - 1 ) ))
            $0.width.centerX.equalTo(self.mainLoginImage)
            $0.top.equalTo(self.mainLoginImage.snp.bottom).offset(105)
        }
        
        
      
        
        
        
    }
    
    
}


