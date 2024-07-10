//
//  ViewController.swift
//  UITester
//
//  Created by 양승완 on 7/4/24.
//

import UIKit
import SnapKit

class BuilderVC: UIViewController {
    
    private let homeArr: [PlayerModel] = [PlayerModel.init(number: "14", name: "승완", position: "ST"),PlayerModel.init(number: "19", name: "정원", position: "CDM"),PlayerModel.init(number: "1", name: "동경", position: "RWB"),PlayerModel.init(number: "99", name: "찬석", position: "LM")]
    private let awayArr: [PlayerModel] = [PlayerModel.init(number: "14", name: "제임스", position: "ST"),PlayerModel.init(number: "19", name: "앨버트", position: "RM"),PlayerModel.init(number: "1", name: "로호", position: "RWB"),PlayerModel.init(number: "99", name: "존 카멜론", position: "LM"),
                                          PlayerModel.init(number: "42", name: "스테판 커리", position: "GK")]
    
    lazy var rightButton: UIBarButtonItem = {
 
        let button = UIBarButtonItem(title: "완료", style: .plain, target: self, action: nil)

        button.tag = 2

        return button
        
        
        
    }()
    
    let homeTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(PlayerCell.self, forCellReuseIdentifier: "PlayerCell1")
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
        tableView.register(PlayerCell.self, forCellReuseIdentifier: "PlayerCell2")
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
        
        setTableView()
        setUI()
        // Do any additional setup after loading the view.
    }
    
    func setTableView() {
        homeTableView.dataSource = self
        homeTableView.delegate = self
        
        awayTableView.dataSource = self
        awayTableView.delegate = self
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
//            $0.top.equalTo(self.teamNameStackView.snp.bottom)
//            $0.leading.bottom.equalTo(self.view.safeAreaLayoutGuide)
//            $0.trailing.equalTo(self.view.snp.centerX)
            $0.width.equalTo(self.view.frame.width / 2 - 0.5)
        }
        
        self.awayTableView.snp.makeConstraints {
//            $0.top.equalTo(self.teamNameStackView.snp.bottom)
//            $0.trailing.bottom.equalTo(self.view.safeAreaLayoutGuide)
//            $0.leading.equalTo(self.view.snp.centerX)
            $0.width.equalTo(self.view.frame.width / 2 - 0.5)
        }
        self.teamPlayerStackView.snp.makeConstraints {
            $0.top.equalTo(self.teamNameStackView.snp.bottom)
            $0.leading.trailing.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
        
        
        
        
        
        
        
        
    }
    
    
}

class PlayerCell: UITableViewCell {
    
    var nameLabel : UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        return label
        
    }()
    let numberLabel = {
        let label = UILabel()
        label.textAlignment = .center
        return label
        
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .clear
        setUI()
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUI() {
        self.contentView.addSubview(nameLabel)
        self.contentView.addSubview(numberLabel)
        
        self.numberLabel.snp.makeConstraints {
            $0.centerY.leading.equalTo(self.contentView)
            $0.trailing.equalTo(self.contentView.snp.centerX)
        }
        
        self.nameLabel.snp.makeConstraints {
            $0.centerY.trailing.equalTo(self.contentView)
            $0.leading.equalTo(self.contentView.snp.centerX)
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
            let cell = tableView.dequeueReusableCell(withIdentifier: "PlayerCell1", for: indexPath) as! PlayerCell
            cell.nameLabel.text = self.homeArr[indexPath.row].name
            cell.numberLabel.text = self.homeArr[indexPath.row].number
            cell.selectionStyle = .none
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PlayerCell2", for: indexPath) as! PlayerCell
            cell.nameLabel.text = self.awayArr[indexPath.row].name
            cell.numberLabel.text = self.awayArr[indexPath.row].number
            cell.selectionStyle = .none
            
            return cell
        }
    }
    
}
