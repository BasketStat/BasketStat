import UIKit
import GoogleSignIn
import FirebaseAuth
import Firebase
import SnapKit
import CryptoKit
import CryptoTokenKit
import AuthenticationServices

class LoginViewController: UIViewController {
    
    
    
    fileprivate var currentNonce: String?
    
    
    

    
    var kakaoButton: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 254 / 255, green: 229 / 255, blue: 0 / 255, alpha: 1)
        view.layer.cornerRadius = 30
        
        let label = UILabel()
        label.text = "카카오로 로그인"
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: 18 )
        
        let image = UIImageView(image: UIImage(named: "kakaoLogin.png"))
        
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
        
        
        
        
        return view
    }()
    
    var appleButton: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.layer.cornerRadius = 30
        
        let label = UILabel()
        label.text = "Apple로 로그인"
        label.textColor = .white
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: 18 )
        
        
        let image = UIImageView(image: UIImage(named: "appleLogin.png"))
        
        
        view.addSubview(label)
        view.addSubview(image)
        
        
        label.snp.makeConstraints {
            $0.center.equalTo(view)
        }
        image.snp.makeConstraints {
            $0.width.equalTo(20)
            $0.height.equalTo(22)
            $0.leading.equalTo(view).inset(20)
            $0.centerY.equalTo(view).offset(-2)
        }
        
        return view
    }()
    
    
    var googleLoginButton = GIDSignInButton()
    
    var googleButton: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 30
        
        let label = UILabel()
        label.text = "Google 로그인"
        label.textColor = .black
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: 18 )
        
        
        let image = UIImageView(image: UIImage(named: "googleLogin.png"))
        
        
        view.addSubview(label)
        view.addSubview(image)
        
        
        label.snp.makeConstraints {
            $0.center.equalTo(view)
        }
        image.snp.makeConstraints {
            $0.width.equalTo(20)
            $0.height.equalTo(22)
            $0.leading.equalTo(view).inset(20)
            $0.centerY.equalTo(view).offset(-2)
        }
        
        return view
    }()
    
    
    
    
    
    lazy var loginStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [ kakaoButton, appleButton, googleButton ])
        stackView.axis = .vertical
        stackView.spacing = 15
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        
        
        
        
        
        return stackView
        
        
    }()
    

    let mainLoginImage: UIImageView = {
        let image = UIImageView(image: UIImage(named: "mainImage.jpeg"))
        
        return image
        
    }()
    
    let mainView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 14 / 255, green: 38 / 255, blue: 60 / 255, alpha: 1)
        
        view.layer.cornerRadius = 8
        
        return view
        
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        self.setUI()
        
        let appleLoginTapGesture = UITapGestureRecognizer(target: self, action: #selector(AppleLoginTapped))
        let googleLoginTapGesture = UITapGestureRecognizer(target: self, action: #selector(googleLoginTapped))
        let kakaoLoginTapGesture = UITapGestureRecognizer(target: self, action: #selector(kakaoLoginTapped))
        appleButton.addGestureRecognizer(appleLoginTapGesture)
        googleButton.addGestureRecognizer(googleLoginTapGesture)
        kakaoButton.addGestureRecognizer(kakaoLoginTapGesture)
        
        
        
    }
    
    @objc
    func AppleLoginTapped() {
        
        self.startSignInWithAppleFlow()
    }
    
    
    @objc
    func kakaoLoginTapped() {
        
        KakaoService.shared.kakaoLogin()
    }
    
    
    @objc
    func googleLoginTapped() {
            // 구글 인증
            guard let clientID = FirebaseApp.app()?.options.clientID else { return }
            let config = GIDConfiguration(clientID: clientID)
            
            GIDSignIn.sharedInstance.signIn(withPresenting: self) { [weak self] result, error in
                   
               if let error {
                   return
               }
                   
               // 로그인 성공 시 result에서 user와 ID Token 추출
               guard let user = result?.user, let idToken = user.idToken?.tokenString else {
                   return
               }
                   
               // user에서 Access Token 추출
               let accessToken = user.accessToken.tokenString
               
               // Token을 토대로 Credential(사용자 인증 정보) 생성
               let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)
            Auth.auth().signIn(with: credential) {_,_ in
                
            }
           }
        }
      
    @objc
    func AppleRevokeTapped() {
        
        self.signOut()
    }
    
    
    func setUI() {
        let HEIGHT: CGFloat = 60
        
        
        view.addSubview(mainView)
        view.addSubview(mainLoginImage)
        view.addSubview(loginStackView)
        
        
        
        self.mainView.snp.makeConstraints {
            $0.top.bottom.trailing.leading.equalTo(self.view)
        }
        self.mainLoginImage.snp.makeConstraints {
            $0.width.height.equalTo(240)
            $0.center.equalTo(self.view)
        }
        self.loginStackView.snp.makeConstraints {
            $0.height.equalTo( HEIGHT * 3 + 20 )
            $0.leading.trailing.equalTo(self.view).inset(20)
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(60)
        }
        
        
        
        
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}


extension LoginViewController {
    
    
    
    
    func signIn(credential: OAuthCredential) {
        Auth.auth().signIn(with: credential) { (authResult, error) in
            if let error {
                // Error. If error.code == .MissingOrInvalidNonce, make sure
                // you're sending the SHA256-hashed nonce as a hex string with
                // your request to Apple.
                print(error.localizedDescription)
                return
            } else {
                self.navigationController?.viewControllers = [BuilderVC()]
                
            }
        }
    }
    
   
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

extension LoginViewController: ASAuthorizationControllerDelegate {
    
    
    
    
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
            
            self.signIn(credential: credential)
            

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


extension LoginViewController: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window ?? UIWindow()
    }
}
