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

class PickPlayersVC: UIViewController, UITableViewDelegate, View {
    
    var disposeBag = DisposeBag()
    
    let searchController = UISearchController(searchResultsController: nil)
   
    
    let checkBtn = UIButton().then {
        $0.setTitle("확인", for: .normal)
        
        $0.titleLabel?.textColor = .white
        $0.titleLabel?.font = .systemFont(ofSize: 14)
        $0.backgroundColor = .customOrange()
        $0.layer.cornerRadius = 4
    }
    
    
    let teamProfile = UIImageView().then {
        
        $0.backgroundColor = .fromRGB(217, 217, 217, 1)
        $0.layer.cornerRadius = 6
    }
    
    lazy var tableView = UITableView().then {
        $0.backgroundColor = .clear
        $0.rowHeight = 60
        $0.backgroundColor = .mainColor().withAlphaComponent(0.8)
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        
        
        if #available(iOS 13.0, *) {
            searchController.searchBar.searchTextField.textColor =  .mainWhite()
            
        }
    }
    
    override func viewDidLoad() {
        
        
        self.setNavigationBar()
        self.setUI()
        //   self.setSearchController()
        self.setPlayerTableView()
        
        self.navigationItem.titleView?.backgroundColor = .mainColor()
        
    }
    
    
    
    func bind(reactor: PickPlayersReactor) {
        
        reactor.state.map { _ in reactor.currentState.popToBuilderVC  }.subscribe{ check in
            if check {
                if let builderVC = self.navigationController?.viewControllers.first(where: { $0 is BuilderVC }) as? BuilderVC,
                   let builderReactor = builderVC.reactor {
                    builderReactor.searchReactorTeam.onNext(reactor.currentState.teamModel)
                }
                
                // ViewController2와 ViewController3 pop
                if let vc = self.navigationController?.viewControllers.first(where: { $0 is BuilderVC }) {
                    self.navigationController?.popToViewController(vc, animated: false)
                }
                
                
            }
        }.disposed(by: disposeBag)
        
        self.rx.methodInvoked(#selector(self.viewWillAppear(_:)))
            .map { _ in Reactor.Action.viewWillAppear }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        
        reactor.state.map { $0.teamModel }.subscribe(onNext: { [weak self] teamModel in
            guard let self else {return}
            let url = URL(string: teamModel.teamImageUrl)
            DispatchQueue.main.async {
                let processor = DownsamplingImageProcessor(size: self.teamProfile.bounds.size)
                |> RoundCornerImageProcessor(cornerRadius: 25)
                self.teamProfile.kf.indicatorType = .activity
                self.teamProfile.kf.setImage(
                    with: url,
                    placeholder: UIImage(),
                    options: [
                        .processor(processor),
                        .scaleFactor(UIScreen.main.scale),
                        .transition(.fade(1)),
                        .cacheOriginalImage
                    ])
            }
            
        }).disposed(by: disposeBag)
        
        reactor.state.map { $0.playerArr }
            .bind(to: self.tableView.rx.items(
                cellIdentifier: "PlayerSearchCheckboxCell",
                cellType: PlayerSearchCell.self)
            ) { index, item, cell in
                
                if item.isPicked {
                    cell.backgroundColor = .white.withAlphaComponent(0.2)
                } else {
                    cell.backgroundColor = .clear
                }
                
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
                cell.numberLabel.text = item.number
                
                
                cell.selectionStyle = UITableViewCell.SelectionStyle.none
            }.disposed(by: self.disposeBag)
        
        checkBtn.rx.tapGesture().when(.recognized).map { _ in Reactor.Action.popToBuilderVC }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        //        self.searchController.searchBar.rx.text.orEmpty.skip(1).throttle(.milliseconds(300), scheduler: MainScheduler.instance)
        //            .distinctUntilChanged().map { Reactor.Action.searchPlayerText($0) }.bind(to: reactor.action ).disposed(by: self.disposeBag)
        
        
        
    }
    
    func setPlayerTableView() {
        
        
        self.tableView.register(PlayerSearchCell.self , forCellReuseIdentifier: "PlayerSearchCheckboxCell")
        
        self.tableView.rx.itemSelected.subscribe { index in
            guard let indexPath = index.element else {return}
            
            if self.reactor?.currentState.playerArr[indexPath.row].isPicked == true {
                self.confirm(title: "선수제외", message: "이 선수를 선택 목록에서 제외 하시겠습니까?", onConfirm: {
                    self.reactor?.action.onNext(.exception(indexPath.row))
                }, over: self)
                return
            }
            
            if self.reactor?.currentState.playerArr.filter({ $0.isPicked == true }).count ?? 0 < 3 {
                self.numberWrite(title: "번호 입력", message: "선수 번호 입력 후 확인 버튼을 눌러주세요", onConfirm: {
                    let picked = self.reactor?.currentState.teamModel.pickedMemebers ?? []
                    let number = self.reactor?.currentState.playerNumber
                    
                    
                    if !picked.map({ $0.number }).contains(number) {
                        
                        self.reactor?.action.onNext(.pickFin(indexPath.row))

                    } else {
                        self.showAutoDismissAlert(on: self, title: "선수 번호가 중복됩니다", message: "다른 선수 번호를 입력해주세요", duration: 2.0)
                        self.reactor?.action.onNext(.pickPlayerNum(""))

                    }
                    
                }, over: self)
            } else {
                self.confirm(title: "초과", message: "선수 숫자가 5명이 넘었습니다", onConfirm: {
                    
                }, over: self)
            }
            
            
            
            
        }.disposed(by: self.disposeBag)
        
        
        
    }
    
    
    func setSearchController() {
        
        
        self.searchController.searchBar
            .searchTextField
            .attributedPlaceholder = NSAttributedString(string: "참가 선수를 입력하여 주세요", attributes: [NSAttributedString.Key.foregroundColor: UIColor.mainWhite()])
        self.searchController.searchBar.tintColor = .mainWhite()
        self.searchController.searchBar.searchTextField.leftView?.tintColor = .mainWhite()
        self.searchController.hidesNavigationBarDuringPresentation = false
        self.searchController.searchBar.tintColor = .mainWhite()
        // self.navigationItem.searchController = self.searchController
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
        self.view.addSubview(self.teamProfile)
        self.view.addSubview(self.checkBtn)
        
        self.tableView.snp.makeConstraints {
            $0.bottom.leading.trailing.equalToSuperview().inset(20)
            $0.top.equalToSuperview().inset(400)
        }
        
        self.teamProfile.snp.makeConstraints {
            $0.width.height.equalTo(200)
            $0.top.equalToSuperview().inset(150)
            $0.centerX.equalToSuperview()
        }
        
        self.checkBtn.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(50)
            $0.height.equalTo(40)
            $0.width.equalTo(170)
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
            textField.rx.text.orEmpty.map { index in Reactor.Action.pickPlayerNum(index) }.bind(to: self.reactor!.action ).disposed(by: self.disposeBag)
            
            
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
    
    func showAutoDismissAlert(on viewController: UIViewController, title: String, message: String, duration: Double) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        // ViewController에 알림창 표시
        viewController.present(alert, animated: true, completion: nil)
        
        // duration 이후에 알림창 자동으로 닫기
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            alert.dismiss(animated: true, completion: nil)
        }
    }
    
}


