//
//  ViewController.swift
//  UITester
//
//  Created by 양승완 on 7/4/24.
//

import UIKit
import SnapKit
import ReactorKit

class BuilderVC: UIViewController, View {
    
    private let reactor = BuilderReactor(provider: ServiceProvider())
    var disposeBag = DisposeBag()
    
    
    
    private let homeArr: [PlayerModel] = []
    private let awayArr: [PlayerModel] = []
    
    lazy var rightButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "완료", style: .plain, target: self, action: nil)
        button.tag = 2
        return button

    }()
    
    let homeTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(PlayerBuilderCell.self, forCellReuseIdentifier: "PlayerCell1")
        tableView.isScrollEnabled = false
        tableView.rowHeight = 50
        tableView.backgroundColor = .systemPink.withAlphaComponent(0.2)

        return tableView
    }()
    let borderView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.snp.makeConstraints { $0.width.equalTo(1) }
        return view
    }()
    let awayTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(PlayerBuilderCell.self, forCellReuseIdentifier: "PlayerCell2")
        tableView.isScrollEnabled = false
        tableView.rowHeight = 50
        tableView.backgroundColor =  .systemBlue.withAlphaComponent(0.2)
        return tableView
    }()
    
    let homeLogo = UIImageView(image: UIImage(named: "image1.png"))
    let awayLogo = UIImageView(image: UIImage(named: "image2.png"))
    
    let homeName: UILabel = {
        let label = UILabel()
        label.text = "Lakers"
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: 20)

        return label
    }()
    
    let awayName: UILabel = {
        let label = UILabel()
        label.text = "Basketball"
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: 20)
        return label
    }()
    
    lazy var teamlogoStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [self.homeLogo, self.awayLogo])
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        stackView.axis = .horizontal
        
        return stackView
    }()
    
    lazy var teamNameStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [self.homeName, self.awayName])
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        stackView.axis = .horizontal
        
        return stackView
    }()
    
    lazy var teamPlayerStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [self.homeTableView, self.borderView, self.awayTableView])
        stackView.alignment = .fill
        stackView.distribution = .fillProportionally
        stackView.axis = .horizontal
        stackView.layer.borderWidth = 1
        return stackView
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = "Team Builder"
        self.navigationItem.rightBarButtonItem = self.rightButton
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setTableView()
        self.setUI()

        self.bind(reactor: self.reactor)

       
        // Do any additional setup after loading the view.
    }
    
    func setTableView() {
        homeTableView.dataSource = self
        homeTableView.delegate = self
        
        awayTableView.dataSource = self
        awayTableView.delegate = self
    }
    
    func bind(reactor: BuilderReactor) {
        
        
        
        reactor.state.map { _ in reactor.currentState.homeArr }
            .bind(to: self.homeTableView.rx.items(
                        cellIdentifier: "PlayerCell1",
                        cellType: PlayerBuilderCell.self)
                    ) { index, item, cell in
                cell.nameLabel.text = item.nickname
                    }.disposed(by: disposeBag)
        
        reactor.state.map { _ in reactor.currentState.awayArr }
            .bind(to: self.awayTableView.rx.items(
                        cellIdentifier: "PlayerCell2",
                        cellType: PlayerBuilderCell.self)
                    ) { index, item, cell in
                cell.nameLabel.text = item.nickname
                    }.disposed(by: disposeBag)
         
    }
    
    
    func setUI() {
        self.view.addSubview(teamlogoStackView)
        self.view.addSubview(teamNameStackView)
        self.view.addSubview(teamPlayerStackView)
        
     
        self.homeLogo.contentMode = .scaleAspectFit
        self.awayLogo.contentMode = .scaleAspectFit
        
      
        self.teamlogoStackView.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(self.view.safeAreaLayoutGuide)
            $0.height.equalTo(180)
        }
        
        self.teamNameStackView.snp.makeConstraints {
            $0.top.equalTo(self.teamlogoStackView.snp.bottom)
            $0.leading.trailing.equalTo(self.view.safeAreaLayoutGuide)
            $0.height.equalTo(30)
        }
        self.homeTableView.snp.makeConstraints {

            $0.width.equalTo(self.view.frame.width / 2 - 0.5)
        }
        
        self.awayTableView.snp.makeConstraints {

            $0.width.equalTo(self.view.frame.width / 2 - 0.5)
        }
        self.teamPlayerStackView.snp.makeConstraints {
            $0.top.equalTo(self.teamNameStackView.snp.bottom)
            $0.leading.trailing.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
        
        
        
        
        
        
        
        
    }
    
    
}






extension BuilderVC: UITableViewDataSource, UITableViewDelegate  {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print("selected")
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        
        if tableView == homeTableView {
            return homeArr.count
        } else {
            return awayArr.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == homeTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PlayerCell1", for: indexPath) as! PlayerBuilderCell
            cell.nameLabel.text = self.homeArr[indexPath.row].nickname
            //cell.numberLabel.text = self.homeArr[indexPath.row]
            cell.selectionStyle = .none
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PlayerCell2", for: indexPath) as! PlayerBuilderCell
            cell.nameLabel.text = self.awayArr[indexPath.row].nickname
           // cell.numberLabel.text = self.awayArr[indexPath.row].number
            cell.selectionStyle = .none
            
            return cell
        }
    }
    
}

class AddCell: UITableViewCell {
    
    let plusImage = UIImageView(image: UIImage(systemName: "plus")).then {
        $0.tintColor = .white
        
        
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .mainColor().withAlphaComponent(0.2)
        self.setUI()
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUI() {
        self.addSubview(plusImage)
        
        self.plusImage.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.height.equalTo(40)
        }

    }
}
