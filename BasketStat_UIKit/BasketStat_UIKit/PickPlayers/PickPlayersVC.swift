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
        
        
//        self.searchController.searchBar.rx.text.orEmpty.skip(1).throttle(.milliseconds(300), scheduler: MainScheduler.instance)
//            .distinctUntilChanged().map { Reactor.Action.searchPlayerText($0) }.bind(to: reactor.action ).disposed(by: self.disposeBag)
        
 

    }
    
    func setPlayerTableView() {
        
        
        self.tableView.register(PlayerSearchCell.self , forCellReuseIdentifier: "PlayerSearchCheckboxCell")
        tableView.rx.modelSelected(PlayerModel.self)
            .subscribe { item in
                
                self.numberWrite(title: "번호 입력", message: "선수 번호 입력 후 확인 버튼을 눌러주세요", onConfirm: {
                    print("alertTapped \(item)")
                    
                }, over: self)
                
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
        
        self.tableView.snp.makeConstraints {
            $0.bottom.leading.trailing.equalToSuperview().inset(20)
            $0.top.equalToSuperview().inset(400)
            
        }
        
        self.teamProfile.snp.makeConstraints {
            $0.width.height.equalTo(200)
            $0.top.equalToSuperview().inset(150)
            $0.centerX.equalToSuperview()
            
                
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
//            textField.rx.text.orEmpty.bind(to: self.alertTextField ).disposed(by: self.disposeBag)
            
            
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


