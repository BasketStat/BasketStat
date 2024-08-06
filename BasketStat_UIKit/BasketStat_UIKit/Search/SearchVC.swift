//
//  SearchVC.swift
//  UITester
//
//  Created by 양승완 on 7/4/24.
//

import UIKit
import SnapKit
import ReactorKit
import AlgoliaSearchClient
import Then
import SnapKit


class SearchVC: UIViewController, View {
    
    
    private let reactor = SearchReactor(provider: ServiceProvider())
    var disposeBag = DisposeBag()
    
    let searchController = UISearchController(searchResultsController: nil)
    
    lazy var tableView = UITableView().then {
        $0.delegate = self
        $0.backgroundColor = .mainColor()
        $0.register(PlayerBuilderCell.self , forCellReuseIdentifier: "PlayerCell3")
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        if #available(iOS 13.0, *) {
            searchController.searchBar.searchTextField.textColor =  .mainWhite()
          
        }
    }
    
    override func viewDidLoad() {
        
        self.setUI()
        self.setSearchController()
        self.bind(reactor: self.reactor)
        self.navigationItem.titleView?.backgroundColor = .mainColor()
        
    }
    
    func bind(reactor: SearchReactor) {
        
        
        self.searchController.searchBar.rx.text.orEmpty.throttle(.milliseconds(300), scheduler: MainScheduler.instance)
            .distinctUntilChanged().map { Reactor.Action.searchText($0) }.bind(to: reactor.action ).disposed(by: self.disposeBag)
        
        
        reactor.state.map { _ in reactor.currentState.playerArr }
            .bind(to: self.tableView.rx.items(
                cellIdentifier: "PlayerSearchCell",
                cellType: PlayerSearchCell.self)
            ) { index, item, cell in
                cell.nameLabel.text = item.nickname
                
                
                
                
            }.disposed(by: disposeBag)
        
        
    }
    
    func setSearchController() {
        
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.mainWhite()]

        searchController.searchBar
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
    
    func setUI() {
        
        
        
        
        
        
        
        self.view.addSubview(self.tableView)
        
        self.tableView.snp.makeConstraints {
            $0.top.bottom.leading.trailing.equalToSuperview()
            
        }
        
    }
    
    
}
extension SearchVC: UITableViewDelegate {
    
    
    
}

