//
//  SearchVC.swift
//  UITester
//
//  Created by 양승완 on 7/4/24.
//

import UIKit
import Foundation
import SnapKit
import ReactorKit
import AlgoliaSearchClient
import Then
import SnapKit
import Kingfisher

class SearchVC: UIViewController, View, UIScrollViewDelegate {
    
    
    
    
    var titleText = ""
    
    var placeHoldText = ""
    
    var disposeBag = DisposeBag()
    
    let alertTextField = PublishSubject<String>()
    
    let playerAlertTapped = PublishSubject<PlayerModel>()
    
    let teamAlertTapped = PublishSubject<TeamModel>()
    
    let searchController = UISearchController(searchResultsController: nil)
    
    lazy var tableView = UITableView().then {
        $0.backgroundColor = .clear
        $0.rowHeight = 60
        $0.backgroundColor = .mainColor()
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        if #available(iOS 13.0, *) {
            searchController.searchBar.searchTextField.textColor =  .mainWhite()
            
        }
    }
    
    override func viewDidLoad() {
        
        
        self.setNavigationBar()
        self.setUI()
        self.setSearchController()
        
        self.navigationItem.titleView?.backgroundColor = .mainColor()
        
    }
    
  
    
    func bind(reactor: SearchReactor) {
        
        
        
        reactor.state.map{ $0.mode } .distinctUntilChanged().subscribe(onNext:{ [weak self] mode in
            guard let self else {return}
            if mode == .playerSearch {
                reactor.state.map { $0.playerArr }
                    .bind(to: self.tableView.rx.items(
                        cellIdentifier: "PlayerSearchCell",
                        cellType: PlayerSearchCell.self)
                    ) { index, item, cell in
                        
                        
                        cell.nameLabel.text = item.nickname
                        cell.positionLabel.text = item.position.rawValue
                        cell.isUserInteractionEnabled = true
                        
                        
                        let url = URL(string: item.profileImageUrl ?? "")
                        let processor = DownsamplingImageProcessor(size: cell.profileImage.bounds.size)
                        |> RoundCornerImageProcessor(cornerRadius: 25)
                        cell.profileImage.kf.indicatorType = .activity
                        cell.profileImage.kf.setImage(
                            with: url,
                            placeholder: UIImage(),
                            options: [
                                .processor(processor),
                                .scaleFactor(UIScreen.main.scale),
                                .transition(.fade(1)),
                                .cacheOriginalImage
                            ])
                        
                        
                        cell.selectionStyle = UITableViewCell.SelectionStyle.none
                        
                    }.disposed(by: self.disposeBag)
                
                
                self.searchController.searchBar.rx.text.orEmpty.skip(1).throttle(.milliseconds(300), scheduler: MainScheduler.instance)
                    .distinctUntilChanged().map { Reactor.Action.searchPlayerText($0) }.bind(to: reactor.action ).disposed(by: self.disposeBag)
                
                self.alertTextField.map { text in Reactor.Action.alertText(text) }.bind(to: reactor.action ).disposed(by: self.disposeBag)
                
                
                self.playerAlertTapped.map { model in Reactor.Action.playerAlertTapped(model) }.bind(to: reactor.action ).disposed(by: self.disposeBag)
                
                    self.setPlayerTableView()
                
                

            // team
            } else if mode == .teamSearch {
                
                
                
                self.teamAlertTapped.map { model in Reactor.Action.teamAlertTapped(model) }.bind(to: reactor.action ).disposed(by: self.disposeBag)
                
                reactor.state.map { $0.teamArr }
                    .bind(to: self.tableView.rx.items(
                        cellIdentifier: "TeamSearchCell",
                        cellType: TeamSearchCell.self)
                    ) { index, item, cell in
                        
                        cell.nameLabel.text = item.teamName
                        cell.isUserInteractionEnabled = true
                        
                        
                        let url = URL(string: item.teamImageUrl)
                        let processor = DownsamplingImageProcessor(size: cell.profileImage.bounds.size)
                        |> RoundCornerImageProcessor(cornerRadius: 25)
                        cell.profileImage.kf.indicatorType = .activity
                        cell.profileImage.kf.setImage(
                            with: url,
                            placeholder: UIImage(),
                            options: [
                                .processor(processor),
                                .scaleFactor(UIScreen.main.scale),
                                .transition(.fade(1)),
                                .cacheOriginalImage
                            ])
                        
                        
                        cell.selectionStyle = UITableViewCell.SelectionStyle.none
                        
                    }.disposed(by: self.disposeBag)
                
                
                self.searchController.searchBar.rx.text.orEmpty.skip(1).throttle(.milliseconds(300), scheduler: MainScheduler.instance)
                    .distinctUntilChanged().map { Reactor.Action.searchTeamText($0) }.bind(to: reactor.action ).disposed(by: self.disposeBag)
                
                
                self.setTeamTableView()

            }
            
            
            
            
        }).disposed(by: disposeBag)
        
        
        
        
        reactor.state.map { $0.popView }.subscribe(onNext: {
            
            if $0 {
                
                guard let viewStacks = self.navigationController?.viewControllers else {return}
                
                for viewController in viewStacks {
                    
                    if let builderVC = viewController as? BuilderVC {
                                       // 출력해보자
                        self.navigationController?.popToViewController(builderVC, animated: true)
                                   }

                }
                
            }
            
        }).disposed(by: disposeBag)
        
        reactor.state.map { $0.pushPickPlayersVC }.distinctUntilChanged().filter { $0 }.map {
            
            _ in reactor.getPushPickPlayersReactor()
        }.bind(onNext: self.pushPickPlayersVC ).disposed(by: disposeBag)
        
        
        
    }
    
    private func pushPickPlayersVC(reactor: PickPlayersReactor) {
        let vc = PickPlayersVC()
        vc.reactor = reactor
        self.navigationController?.pushViewController(vc, animated: false)

    }
    
    
    func setPlayerTableView() {
        
        
            
            self.placeHoldText = "선수 닉네임"
            self.titleText = "선수 검색"
            
        

     
        
        self.tableView.register(PlayerSearchCell.self , forCellReuseIdentifier: "PlayerSearchCell")
        
        tableView.rx.modelSelected(PlayerModel.self)
            .subscribe { item in
                
                
                
                self.numberWrite(title: "번호 입력", message: "선수 번호 입력 후 확인 버튼을 눌러주세요", onConfirm: {
                    self.playerAlertTapped.onNext(item)
                    
                }, over: self)
                
            }.disposed(by: self.disposeBag)
        
        
        
        
        
    }
    
    func setTeamTableView() {
        
        self.placeHoldText = "팀 이름"
        self.titleText = "팀 검색"
        
        self.tableView.register(TeamSearchCell.self , forCellReuseIdentifier: "TeamSearchCell")
        tableView.rx.modelSelected(TeamModel.self)
            .subscribe (onNext:{ [weak self] item in
                guard let self else {return}
                
               
                self.confirm(title: "팀 선택", message: "\(item.teamName) 을/를 선택하시겠습니까?" , onConfirm: {
                    self.teamAlertTapped.onNext(item)
                    
                }, over: self)
                
            }).disposed(by: self.disposeBag)
    }
    
    func setSearchController() {
        
        
        self.searchController.searchBar
            .searchTextField
            .attributedPlaceholder = NSAttributedString(string: "\(self.placeHoldText)을 입력하여 주세요", attributes: [NSAttributedString.Key.foregroundColor: UIColor.mainWhite()])
        self.searchController.searchBar.tintColor = .mainWhite()
        self.searchController.searchBar.searchTextField.leftView?.tintColor = .mainWhite()
        self.searchController.hidesNavigationBarDuringPresentation = false
        self.searchController.searchBar.tintColor = .mainWhite()
        self.navigationItem.searchController = self.searchController
        self.navigationItem.title = self.titleText
        self.navigationItem.hidesSearchBarWhenScrolling = false
        
        
        
    }
    
    func setNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .mainColor()
        appearance.titleTextAttributes = [.foregroundColor: UIColor.mainWhite()]
        
        self.navigationController?.navigationBar.standardAppearance = appearance
        self.navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    
    func setUI() {
        
        self.view.addSubview(self.tableView)
        
        self.tableView.snp.makeConstraints {
            $0.top.bottom.leading.trailing.equalToSuperview()
        }
        
    }
    
    
    typealias Action = () -> Void
    
    func confirm(title: String, message: String?, onConfirm: @escaping Action, over viewController: UIViewController) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        
        let confirm =  UIAlertAction(title: "확인", style: .default, handler: { (_) in
            onConfirm()
        })
        confirm.setValue( UIColor.black, forKey: "titleTextColor")
        
       
        
        ac.addAction(confirm)
        
        ac.addAction(self.cancel)
        
        viewController.present(ac, animated: true)
    }
    
    
    func numberWrite(title: String, message: String?, onConfirm: @escaping Action, over viewController: UIViewController) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        
        let gotIn =  UIAlertAction(title: "확인", style: .default, handler: { (_) in
            onConfirm()
        })
        gotIn.setValue( UIColor.black, forKey: "titleTextColor")
        
        ac.addTextField(configurationHandler: { [weak self] textField in
            guard let self else {return}
            textField.textAlignment = .center
            textField.rx.text.orEmpty.bind(to: self.alertTextField ).disposed(by: self.disposeBag)
            
            
        })
        
        ac.addAction(gotIn)
        
        ac.addAction(self.cancel)
        
        viewController.present(ac, animated: true)
    }
    var cancel: UIAlertAction {
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        cancel.setValue( UIColor.black, forKey: "titleTextColor")
        return cancel
    }
    
}


