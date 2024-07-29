import UIKit
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

class SignUpVC: UIViewController {
    
    var cnt = 0
    
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setUI()
        self.setBind()

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
    
    let tallTextView = UIView().then {
        $0.layer.cornerRadius = 2
        $0.backgroundColor = .fromRGB(217, 217, 217, 0.2)
    
        let textField = UITextField().then {
            $0.backgroundColor = .clear
            $0.textColor = .white.withAlphaComponent(0.5)
            $0.tintColor = .white.withAlphaComponent(0.5)
            $0.attributedPlaceholder = NSAttributedString(string: "키를 입력해주세요", attributes: [NSAttributedString.Key.foregroundColor : UIColor.white.withAlphaComponent(0.5)])
        }
        
        
        $0.addSubview(textField)
        
        textField.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.top.equalToSuperview().inset(10)
            $0.bottom.equalToSuperview().offset(-10)
        }
        
    }
    
    let weightTextView = UIView().then {
        $0.layer.cornerRadius = 2
        $0.backgroundColor = .fromRGB(217, 217, 217, 0.2)
        
        let textField = UITextField().then {
            $0.tintColor = .white.withAlphaComponent(0.5)
            $0.backgroundColor = .clear
            $0.textColor = .white.withAlphaComponent(0.5)
            $0.attributedPlaceholder = NSAttributedString(string: "몸무게를 입력해주세요", attributes: [NSAttributedString.Key.foregroundColor : UIColor.white.withAlphaComponent(0.5)])
 
        }
        $0.addSubview(textField)
        
        textField.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.top.equalToSuperview().inset(10)
            $0.bottom.equalToSuperview().offset(-10)
        }
    }
    
    
    lazy var dropDown = DropDown().then {
        //$0.dataSource = ["test1", "test2", "test3"]
        $0.anchorView = self.positionTextView
        $0.bottomOffset = CGPoint(x: 0, y:40)
        $0.backgroundColor = .fromRGB(217, 217, 217, 0.2)
        $0.textColor = .white.withAlphaComponent(0.5)

    }
    
    var polygon = UIImageView(image: UIImage(named: "Polygon.png")).then {
        $0.isUserInteractionEnabled = true
    }
    

    
    lazy var positionTextView = UIView().then {
        $0.layer.cornerRadius = 2
        $0.backgroundColor = .fromRGB(217, 217, 217, 0.2)
        $0.isUserInteractionEnabled = true

        let label = UILabel().then {
            $0.tintColor = .white.withAlphaComponent(0.5)
            $0.text = "포지션을 선택해주세요"
            $0.textColor = .white.withAlphaComponent(0.5)
            
        }
        
        $0.addSubview(label)
        $0.addSubview(self.polygon)
        
        label.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(16)
            $0.top.equalToSuperview().inset(10)
            $0.bottom.equalToSuperview().offset(-10)
        }
        
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
      
        let index1 = ["test1", "test2","test3","test4",]
        let index2 = ["테스트", "테스트","테스트","테스트",]


        dropDown.customCellConfiguration = { (index: Index, item: String, cell: DropDownCell) -> Void in
           guard let cell = cell as? PostionCell else { return }

           // Setup your custom UI components
            cell.krLabel.text = index1[index]
            cell.engLabel.text = index2[index]
        }
        
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
            $0.top.equalToSuperview().inset(420)
        }
        
     
        self.profileImageView.snp.makeConstraints {
            $0.width.height.equalTo(174)
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(150)
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
        
        
        
        
    }
    
    func setBind() {
        
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

            
        } else if let image = info[.originalImage] as? UIImage {
            self.profileImageView.image = image
        }

        
        

        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
}

class PostionCell: DropDownCell {
   
    let krLabel = UILabel()
    let engLabel = UILabel()
    

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        krLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(10)
        } 
        engLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(10)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}
