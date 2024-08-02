import UIKit
import ReactorKit
import DropDown
import RxSwift
import RxCocoa
import Photos
import GoogleSignIn
import FirebaseAuth
import Firebase
import SnapKit
import AuthenticationServices
import Then
import RxGesture

class SignUpVC: UIViewController, View {
    
   
    
    private let reactor = SignUpReactor(provider: ServiceProvider())
    var disposeBag = DisposeBag()
    
    let positionBinder = PublishSubject<Int>()
    let profileImageBinder = PublishSubject<UIImage?>()
        
    let index = ["PG(포인트 가드)", "SG(슈팅 가드)","SF(스몰 포워드)", "PF(파워 포워드)", "C(센터)"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        KeyBoard.shared.KeyBoardSetting(vc: self)

        
        self.setUI()
        self.bind(reactor: self.reactor)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        KeyBoard.shared.removeOb(vc: self)
    }
    
    
    let mainView = UIView().then {
        $0.backgroundColor = .mainColor()
    }
    
    let profileImageView = UIImageView(image: UIImage(named: "DefaultProfileImage.png")).then {
        
        $0.layer.cornerRadius = 87
        $0.layer.masksToBounds = true
    }
    
    let nicknameTextField = UITextField().then {
        $0.textAlignment = .center
        $0.backgroundColor = .clear
        $0.textColor = .white.withAlphaComponent(0.5)
        $0.tintColor = .white.withAlphaComponent(0.5)
        $0.attributedPlaceholder = NSAttributedString(string: "닉네임을 입력해주세요", attributes: [NSAttributedString.Key.foregroundColor : UIColor.white.withAlphaComponent(0.5)])
    }
    
    
    let tallTextField = UITextField().then {
        $0.keyboardType = .numberPad
        $0.backgroundColor = .clear
        $0.textColor = .white.withAlphaComponent(0.5)
        $0.tintColor = .white.withAlphaComponent(0.5)
        $0.attributedPlaceholder = NSAttributedString(string: "키를 입력해주세요", attributes: [NSAttributedString.Key.foregroundColor : UIColor.white.withAlphaComponent(0.5)])
    }
    lazy var tallTextView = UIView().then {
        $0.layer.cornerRadius = 2
        $0.backgroundColor = .fromRGB(217, 217, 217, 0.2)
        
        
        
        
        $0.addSubview(tallTextField)
        
        tallTextField.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.top.equalToSuperview().inset(10)
            $0.bottom.equalToSuperview().offset(-10)
        }
        
    }
    
    let weightTextField = UITextField().then {
        $0.keyboardType = .numberPad

        $0.tintColor = .white.withAlphaComponent(0.5)
        $0.backgroundColor = .clear
        $0.textColor = .white.withAlphaComponent(0.5)
        $0.attributedPlaceholder = NSAttributedString(string: "몸무게를 입력해주세요", attributes: [NSAttributedString.Key.foregroundColor : UIColor.white.withAlphaComponent(0.5)])
        
    }
    
    lazy var weightTextView = UIView().then {
        $0.layer.cornerRadius = 2
        $0.backgroundColor = .fromRGB(217, 217, 217, 0.2)
        
        
        $0.addSubview(weightTextField)
        
        weightTextField.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.top.equalToSuperview().inset(10)
            $0.bottom.equalToSuperview().offset(-10)
        }
    }
    
    
    lazy var dropDown = DropDown().then {
        $0.anchorView = self.positionTextView
        $0.bottomOffset = CGPoint(x: 0, y:40)
        $0.backgroundColor = .black.withAlphaComponent(0.2)
        $0.textColor = .white.withAlphaComponent(0.5)
        $0.cellHeight = 36
        
        
        
    }
    
    var polygon = UIImageView(image: UIImage(named: "Polygon.png")).then {
        $0.isUserInteractionEnabled = true
    }
    
    
    let positionLabel = UILabel().then {
        $0.tintColor = .white.withAlphaComponent(0.5)
        $0.text = "포지션을 선택해주세요"
        $0.textColor = .white.withAlphaComponent(0.5)
        
    }
    lazy var positionTextView = UIView().then {
        $0.layer.cornerRadius = 2
        $0.backgroundColor = .fromRGB(217, 217, 217, 0.2)
        $0.isUserInteractionEnabled = true
        
        
        
        $0.addSubview(positionLabel)
        $0.addSubview(self.polygon)
        
        
        
        self.polygon.snp.makeConstraints {
            
            $0.trailing.equalToSuperview().inset(16)
            
            $0.centerY.equalToSuperview()
            
            
        }
        
    }
    lazy var stackView = UIStackView(arrangedSubviews: [self.tallTextView, self.weightTextView, self.positionTextView]).then {
        
        $0.spacing = 16
        $0.alignment = .fill
        $0.distribution = .fillEqually
        $0.axis = .vertical
        $0.layer.cornerRadius = 2
    }
    
    let checkBtn = UIButton().then {
        $0.setTitle("확인", for: .normal)
        
        $0.titleLabel?.textColor = .white
        $0.titleLabel?.font = .systemFont(ofSize: 14)
        $0.backgroundColor = .btnColor()
        $0.layer.cornerRadius = 4
    }
    
    
    
    func setUI() {
        
        dropDown.dataSource = index
        
        
        
        self.view.addSubview(self.mainView)
        self.view.addSubview(self.stackView)
        self.view.addSubview(self.profileImageView)
        self.view.addSubview(self.nicknameTextField)
        self.view.addSubview(self.checkBtn)
        
        
        self.mainView.snp.makeConstraints {
            $0.width.height.equalToSuperview()
            
        }
        
        
        
        
        self.stackView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(50)
            $0.height.equalTo(40 * 3 + (16 * 2))
            $0.top.equalToSuperview().inset(400)
        }
        
        
        self.profileImageView.snp.makeConstraints {
            $0.width.height.equalTo(174)
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(130)
        }
        
        self.nicknameTextField.snp.makeConstraints {
            $0.top.equalTo(self.profileImageView.snp.bottom).offset(30)
            $0.centerX.equalToSuperview()
        }
        
        self.checkBtn.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(50)
            $0.height.equalTo(40)
            $0.width.equalTo(170)
            
        }
        self.positionLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(16)
            $0.top.equalToSuperview().inset(10)
            $0.bottom.equalToSuperview().offset(-10)
        }
        
        
        
        
    }
    
    func bind(reactor: SignUpReactor) {
        
        
        self.profileImageView.rx.tapGesture().when(.recognized).subscribe(onNext: { _ in
            
            self.actionSheetAlert()
            
        }).disposed(by: disposeBag)
        
        
        self.positionTextView.rx.tapGesture().when(.recognized).subscribe(onNext: { _ in
            
            self.dropDown.show()
            self.polygon.transform = CGAffineTransformMakeScale(1, -1);
            
            
        }).disposed(by: disposeBag)
        
        
        
        dropDown.willShowAction = { [unowned self] in
            self.polygon.transform = CGAffineTransformMakeScale(-1, 1);
            
        }
        dropDown.cancelAction = { [unowned self] in
            self.polygon.transform = CGAffineTransformMakeScale(-1, 1);
            
        }
        
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.polygon.transform = CGAffineTransformMakeScale(-1, 1);
            self.positionLabel.text = item
            
            self.positionBinder.onNext(index)
            self.dropDown.clearSelection()
        }
        
        reactor.state.map { $0.isLoginButtonEnabled }.subscribe(onNext: { val in
            
            if val {
                self.checkBtn.backgroundColor = .btnColor()
            } else {
                self.checkBtn.backgroundColor = .lightGray
                
            }
            
            self.checkBtn.isEnabled = val
            
        }).disposed(by: disposeBag)
        
        self.profileImageBinder.distinctUntilChanged().map { image in
            Reactor.Action.setProfileImage(image) }.bind(to: reactor.action).disposed(by: disposeBag)
        
        self.nicknameTextField.rx.text.orEmpty.distinctUntilChanged().map { text in Reactor.Action.setNickname(text) }.bind(to: reactor.action).disposed(by: disposeBag)
        
        self.tallTextField.rx.text.orEmpty.distinctUntilChanged().map { text in Reactor.Action.setTall(text) }.bind(to: reactor.action).disposed(by: disposeBag)
        
        self.weightTextField.rx.text.orEmpty.distinctUntilChanged().map { text in Reactor.Action.setWeight(text) }.bind(to: reactor.action).disposed(by: disposeBag)
        
        self.positionBinder.distinctUntilChanged().map { index in Reactor.Action.setPosition(index)}.bind(to: reactor.action).disposed(by: disposeBag)
        
        self.checkBtn.rx.tap.map{ Reactor.Action.pushBtn }.bind(to: reactor.action).disposed(by: disposeBag)
        
        reactor.state.map { $0.isPushed }.subscribe(onNext: { val in
            
            if val {
                self.navigationController?.pushViewController( GameStatVC() , animated: false)
            }
            
            
        }).disposed(by: disposeBag)
        
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}

extension SignUpVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func requestCameraPermission() {
        AVCaptureDevice.requestAccess(for: .video, completionHandler: { (granted: Bool) in
            if granted {
                print("카메라 권한 허용")
                DispatchQueue.main.async {
                    
                    self.presentCamera()
                    
                }
                
            } else {
                print("카메라 권한 거부")
                
            }
        })
    }
    func checkAlbumPermission() {
        PHPhotoLibrary.requestAuthorization({ status in
            switch status {
            case .authorized:
                DispatchQueue.main.async {
                    self.presentAlbum()
                }
            case .denied:
                print("앨범")
            case .restricted, .notDetermined:
                print("Album: 선택하지 않음")
            default:
                break
            }
        })
    }
    
    func actionSheetAlert() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        let replaceImage = UIAlertAction(title: "삭제", style: .default ) { [weak self] _ in
            self?.profileImageView.image = UIImage(named: "DefaultProfileImage.png")
            
        }
        let camera = UIAlertAction(title: "카메라", style: .default) { [weak self] _ in
            self?.requestCameraPermission()
        }
        
        let album = UIAlertAction(title: "앨범", style: .default) { [weak self] _ in
            self?.checkAlbumPermission()
        }
        
        alert.addAction(cancel)
        alert.addAction(camera)
        alert.addAction(album)
        alert.addAction(replaceImage)
        
        alert.view.tintColor = .black
        
        present(alert, animated: true, completion: nil)
        
    }
    
    func presentCamera() {
        
        let vc = UIImagePickerController()
        vc.sourceType = .camera
        vc.delegate = self
        vc.allowsEditing = true
        vc.cameraFlashMode = .on
        
        present(vc, animated: true, completion: nil)
    }
    
    func presentAlbum() {
        
        
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        
        present(vc, animated: true, completion: nil)
    }
    
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        print("picker -> \(String(describing: info[UIImagePickerController.InfoKey.imageURL]))")
        
        if let image = info[.editedImage] as? UIImage {
            
            self.profileImageView.image = image
            self.profileImageBinder.onNext(image)
            
        } else if let image = info[.originalImage] as? UIImage {
            self.profileImageView.image = image
            self.profileImageBinder.onNext(image)

            
        }
        
        
        
        
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
}

