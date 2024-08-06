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
import Kingfisher

class SearchVC: UIViewController, View {
    
    
    private let reactor = SearchReactor(provider: ServiceProvider())
    var disposeBag = DisposeBag()
    
    let searchController = UISearchController(searchResultsController: nil)
    
    lazy var tableView = UITableView().then {
        $0.delegate = self
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
                cell.positionLabel.text = item.position.rawValue
                
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
    
    
}
extension SearchVC: UITableViewDelegate {
    
 
    
    
    
}

