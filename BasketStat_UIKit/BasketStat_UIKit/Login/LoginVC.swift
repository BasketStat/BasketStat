import UIKit
import ReactorKit
import GoogleSignIn
import FirebaseAuth
import Firebase
import SnapKit
import CryptoKit
import CryptoTokenKit
import AuthenticationServices
import Then
import RxGesture

class LoginVC: UIViewController, View {
    
    
    private let reactor = LoginReactor(provider: ServiceProvider())
    var disposeBag = DisposeBag()
    fileprivate var currentNonce: String?
    

    let loginOauthCredential = PublishSubject<OAuthCredential>()
    
    
    var kakaoButton = UIView().then { view in
        view.backgroundColor = .fromRGB(254, 229, 0, 1)
        view.layer.cornerRadius = 10
        
        let label = UILabel().then {
            $0.text = "카카오로 로그인"
            $0.textAlignment = .center
            $0.font = .boldSystemFont(ofSize: 18 )
            $0.textColor = .fromRGB(55, 29, 30, 1)
        }
        
        
        let image = UIImageView(image: UIImage(named: "KakaoLogo.png"))
        
        view.addSubview(label)
        view.addSubview(image)
        
        
        label.snp.makeConstraints {
            $0.center.equalTo(view)
        }
        image.snp.makeConstraints {
            $0.height.equalTo(22)
            $0.width.equalTo(24)
            $0.leading.equalTo(view).inset(20)
            $0.centerY.equalTo(view)
        }
        
    }
    
    var appleButton = UIView().then { view in
        
        view.backgroundColor = .black
        view.layer.cornerRadius = 10

        
        let label = UILabel().then {
            $0.text = "Apple로 로그인"
            $0.textColor = .white
            $0.textAlignment = .center
            $0.font = .boldSystemFont(ofSize: 18 )
        }
        
        
        
        let image = UIImageView(image: UIImage(named: "AppleLogo.png"))
        
        
        view.addSubview(label)
        view.addSubview(image)
        
        
        label.snp.makeConstraints {
            $0.center.equalTo(view)
        }
        image.snp.makeConstraints {
            $0.width.equalTo(15.17)
            $0.height.equalTo(18)
            $0.leading.equalTo(view).inset(20)
            $0.centerY.equalTo(view)
        }
        
    }
    
    
    
    var googleButton = UIView().then { view in
        view.backgroundColor = .white
        view.layer.cornerRadius = 10

        
        let label = UILabel().then {
            $0.text = "Google 로그인"
            $0.textColor = .black
            $0.textAlignment = .center
            $0.font = .boldSystemFont(ofSize: 18 )
        }

        
        
        let image = UIImageView(image: UIImage(named: "GoogleLogo.png"))
        
        
        view.addSubview(label)
        view.addSubview(image)
        
        
        label.snp.makeConstraints {
            $0.center.equalTo(view)
        }
        image.snp.makeConstraints {
            $0.width.height.equalTo(20)
            $0.leading.equalTo(view).inset(20)
            $0.centerY.equalTo(view)
        }
        
    }
    
    
    
    
    
    lazy var loginStackView = UIStackView(arrangedSubviews: [ kakaoButton, appleButton, googleButton ]).then {
        
        $0.axis = .vertical
        $0.spacing = 14
        $0.distribution = .fillEqually
        $0.alignment = .fill

    }
    
    
    let mainLoginImage = UIImageView(image: UIImage(named: "mainIcon.png"))
    
    let mainView = UIView().then {
        $0.backgroundColor = .mainColor()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.bind(reactor: self.reactor)
        self.setUI()

       
        
        
    }
    
   
    func bind(reactor: LoginReactor) {
        
        self.appleButton.rx.tapGesture().when(.recognized).subscribe({ _ in
            
            self.startSignInWithAppleFlow()
            
        }).disposed(by: disposeBag)
        
        self.kakaoButton.rx.tapGesture().when(.recognized).map { _ in Reactor.Action.kakaoLogin }.bind(to: reactor.action).disposed(by: self.disposeBag)
        
        self.googleButton.rx.tapGesture().when(.recognized).map { _ in Reactor.Action.googleLogin(self) }.bind(to: reactor.action).disposed(by: self.disposeBag)
        
        self.loginOauthCredential.map{ credential in Reactor.Action.appleLogin(credential) }.bind(to: reactor.action).disposed(by: self.disposeBag)
        
        reactor.state.map { $0.pushSignUp }.distinctUntilChanged().bind { isPushed in
            if isPushed {
                self.navigationController?.viewControllers = [SignUpVC()]
            }
            
        }.disposed(by: self.disposeBag)
        
        reactor.state.map { $0.pushMain }.distinctUntilChanged().bind { isPushed in
            if isPushed {
                self.navigationController?.viewControllers = [MainVC()]
            }
            
        }.disposed(by: self.disposeBag)
        
        
                  
    }
    
    
    

    
 
    
  
    
    
    func setUI() {
        let HEIGHT: CGFloat = 52
        let SPACING: CGFloat = 14
        
        
        
        self.view.addSubview(mainView)
        self.view.addSubview(mainLoginImage)
        self.view.addSubview(loginStackView)
        
        
        self.mainView.snp.makeConstraints {
            $0.top.bottom.trailing.leading.equalToSuperview()
        }
        self.mainLoginImage.snp.makeConstraints {
            $0.width.height.equalTo(310)
            $0.top.equalTo(self.view.safeAreaLayoutGuide).offset(102)
            $0.centerX.equalToSuperview()
        }
        self.loginStackView.snp.makeConstraints {
            $0.height.equalTo( HEIGHT * 3 + ( SPACING * ( 3 - 1 ) ))
            $0.width.centerX.equalTo(self.mainLoginImage)
            $0.top.equalTo(self.mainLoginImage.snp.bottom).offset(105)
        }
 
        
        
        
        
    }
    
    
 
    
    
    
}


extension LoginVC {
    
    
    
    

    
    
    func signOut() {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            print("signOut")
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
    
    func startSignInWithAppleFlow() {
        let nonce = randomNonceString()
        currentNonce = nonce
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = sha256(nonce)
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
        
    }
    
    func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        var randomBytes = [UInt8](repeating: 0, count: length)
        let errorCode = SecRandomCopyBytes(kSecRandomDefault, randomBytes.count, &randomBytes)
        if errorCode != errSecSuccess {
            fatalError(
                "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
            )
        }
        let charset: [Character] =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        let nonce = randomBytes.map { byte in
            // Pick a random character from the set, wrapping around if needed.
            charset[Int(byte) % charset.count]
        }
        return String(nonce)
    }
    
    func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            String(format: "%02x", $0)
        }.joined()
        
        return hashString
    }
}

// AppleLogin
extension LoginVC: ASAuthorizationControllerDelegate {
    
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            guard let nonce = currentNonce else {
                fatalError("Invalid state: A login callback was received, but no login request was sent.")
            }
            guard let appleIDToken = appleIDCredential.identityToken else {
                print("Unable to fetch identity token")
                return
            }
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                return
            }
            print("signIn")
            // Initialize a Firebase credential, including the user's full name.
            let credential = OAuthProvider.appleCredential(withIDToken: idTokenString,
                                                           rawNonce: nonce,
                                                           fullName: appleIDCredential.fullName)
            
            self.loginOauthCredential.onNext(credential)
            
            
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // Handle error.
        print("Sign in with Apple errored: \(error)")
    }
}


func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
    // Handle error.
    print("Sign in with Apple errored: \(error)")
}


extension LoginVC: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window ?? UIWindow()
    }
}
