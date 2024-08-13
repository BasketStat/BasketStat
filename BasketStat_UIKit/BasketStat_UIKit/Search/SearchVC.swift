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
    
    
    var disposeBag = DisposeBag()
    
    let alertTextField = PublishSubject<String>()
    
    let alertTapped = PublishSubject<PlayerModel>()
    
    let searchController = UISearchController(searchResultsController: nil)
    
    lazy var tableView = UITableView().then {
        $0.backgroundColor = .clear
        $0.register(PlayerSearchCell.self , forCellReuseIdentifier: "PlayerSearchCell")
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
        
        self.alertTextField.map { text in Reactor.Action.alertText(text) }.bind(to: reactor.action ).disposed(by: self.disposeBag)
        
        self.searchController.searchBar.rx.text.orEmpty.throttle(.milliseconds(300), scheduler: MainScheduler.instance)
            .distinctUntilChanged().map { Reactor.Action.searchText($0) }.bind(to: reactor.action ).disposed(by: self.disposeBag)
        
        self.alertTapped.map { model in Reactor.Action.alertTapped(model) }.bind(to: reactor.action ).disposed(by: self.disposeBag)
        
        reactor.state.map { $0.playerArr }
            .bind(to: self.tableView.rx.items(
                cellIdentifier: "PlayerSearchCell",
                cellType: PlayerSearchCell.self)
            ) { index, item, cell in
                
                
                
                cell.nameLabel.text = item.nickname
                cell.positionLabel.text = item.position.rawValue
                cell.isUserInteractionEnabled = true
                cell.rx.tapGesture().when(.recognized).subscribe({ [unowned self] _ in
                    
                    self.showRevoke(title: "번호 입력", message: "선수 번호 입력 후 확인 버튼을 눌러주세요", onConfirm: {
                        
                        self.alertTapped.onNext(item)
                        
                    }, over: self)
                    
                }).disposed(by: cell.disposeBag)
                
                
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

            }.disposed(by: disposeBag)
        
        reactor.state.map { $0.popView }.subscribe(onNext: {
            if $0 {
                self.navigationController?.popViewController(animated: true)
            }
            
            
        }).disposed(by: disposeBag)
        
        
        
    }
    
    func setSearchController() {
        

        self.searchController.searchBar
            .searchTextField
            .attributedPlaceholder = NSAttributedString(string: "선수 닉네임을 입력하여 주세요", attributes: [NSAttributedString.Key.foregroundColor: UIColor.mainWhite()])
        self.searchController.searchBar.tintColor = .mainWhite()
        self.searchController.searchBar.searchTextField.leftView?.tintColor = .mainWhite()
        self.searchController.hidesNavigationBarDuringPresentation = false
        self.searchController.searchBar.tintColor = .mainWhite()
        self.navigationItem.searchController = self.searchController
        self.navigationItem.title = "선수 검색"
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
    
    @objc
    func cellTapped() {
        let alert = UIAlertController(title: "입력하라우", message: "당신의 계정!", preferredStyle: .alert)
                  
                  //alert창 속 텍스트 필드 추가하기 1 (아이디 필드)
                  alert.addTextField { idField in
                      idField.placeholder = "ID를 입력"
                  }
                  
                  //alert창 속 텍스트 필드 추가하기 2 (비밀번호 필드)
                  alert.addTextField { passwordField in
                      passwordField.placeholder = "비밀번호 입력"
                      passwordField.isSecureTextEntry = true
                  }
                  
                  
        present(alert, animated: true, completion: nil)
          
    }
    typealias Action = () -> Void
    
    
    func showRevoke(title: String, message: String?, onConfirm: @escaping Action, over viewController: UIViewController) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)

        let gotIn =  UIAlertAction(title: "확인", style: .default, handler: { (_) in
            onConfirm()
        })
        gotIn.setValue( UIColor.black, forKey: "titleTextColor")
        
        ac.addTextField(configurationHandler: { [weak self] textField in
            guard let self else {return}
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


