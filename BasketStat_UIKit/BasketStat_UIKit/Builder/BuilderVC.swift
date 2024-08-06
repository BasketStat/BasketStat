//
//  ViewController.swift
//  UITester
//
//  Created by 양승완 on 7/4/24.
//

import UIKit
import SnapKit
import ReactorKit
import Then
class BuilderVC: UIViewController, View {
    
    private let reactor = BuilderReactor(provider: ServiceProvider())
    var disposeBag = DisposeBag()
    
    
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
  
    private let homeArr: [PlayerModel] = []
    private let awayArr: [PlayerModel] = []
    
    let mainLabel = UILabel().then {
        $0.font = UIFont.customBoldFont(size: 20)
        $0.textColor = .white
        $0.text = "Team Builder"
    }
    
    let homeTableView = UITableView().then {
        $0.register(PlayerBuilderCell.self, forCellReuseIdentifier: "PlayerCell1")
        $0.isScrollEnabled = false
        $0.rowHeight = 50
        $0.backgroundColor = .clear

   
    }
    let borderView = UIView().then {
        $0.backgroundColor = .mainWhite()
        $0.snp.makeConstraints { $0.width.equalTo(1) }
    }
    let awayTableView = UITableView().then {
        $0.register(PlayerBuilderCell.self, forCellReuseIdentifier: "PlayerCell2")
        $0.isScrollEnabled = false
        $0.rowHeight = 50
        $0.backgroundColor = .clear
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
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.mainWhite().cgColor
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.view.backgroundColor = .mainColor()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUI()

        self.bind(reactor: self.reactor)

       
        // Do any additional setup after loading the view.
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
        let VIEW_WIDTH = self.view.frame.width - ( 52 * 2 )
        
        self.view.addSubview(mainLabel)
        self.view.addSubview(homeLogo)
        self.view.addSubview(awayLogo)
        self.view.addSubview(homeName)
        self.view.addSubview(awayName)
        self.view.addSubview(teamPlayerStackView)
        
        self.homeLogo.addSubview(self.homeAddIcon)
        
        
     
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
            $0.leading.trailing.equalTo(self.view.safeAreaLayoutGuide).inset(52)
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


