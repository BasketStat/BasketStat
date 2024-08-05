//
//  FirebaseService.swift
//  UITester
//
//  Created by 양승완 on 7/8/24.
//

import Foundation
import FirebaseAuth
import KakaoSDKAuth
import KakaoSDKUser
import RxSwift

protocol KakaoServiceProtocol {
    func kakaoLogin() -> Completable
}
class KakaoService: BaseService, KakaoServiceProtocol {
    
    var disposeBag = DisposeBag()
    
    var firebaseService = FirebaseService(provider: ServiceProvider())

    
    
    
    
    func kakaoLogin() -> Completable {
        
        Completable.create { completable in
            var outputId: String!
            var outputPassword: String!
            var outputName: String!
            
            
            if AuthApi.hasToken() {
                print("토큰있음1")

                UserApi.shared.accessTokenInfo { tokenInfo, error in

                    if let error = error {
                        print("_________login error_________")
                        print(error)
                        print("토큰 존재하지 않음.")
                        if UserApi.isKakaoTalkLoginAvailable() {

                            print("카카오톡 존재")
                            UserApi.shared.loginWithKakaoTalk { oauthToken, error in
                                print("1")
                                if let error = error {
                                    print(error)
                                } else {
                                    print("새로운 Login")
                                    
                                    _ = oauthToken
                                    
                                    // 로그인 성공 시
                                    UserApi.shared.me { kuser, error in
                                        
                                        if let error = error {
                                            print("------KAKAO: user loading failed------")
                                            print(error)
                                        } else {
                                            
                                            guard let email = (kuser?.kakaoAccount?.email) else { return }
                                            guard let pw =  kuser?.id else {return}
                                            guard let name = (kuser?.kakaoAccount?.profile?.nickname) else {return}
                                            
                                            outputId = "kakao_" + email
                                            outputPassword = "kakao_" + String(describing: pw )
                                            outputName = name
                                            
                                           
                                            self.firebaseService.signIn(email: outputId, password: outputPassword).subscribe({ [weak self] single in
                                                switch single {
                                                case .completed:
                                                    completable(.completed)

                                                case .error(let err):
                                                    completable(.error(err))

                                                }
                                           
                                                
                                            }).disposed(by: self.disposeBag)
                                            
                                            
                                        }
                                    }
                                    
                                    
                                    
                                }
                            }
                            
                        } else {
                            print("토큰있음2")
                            
                            UserApi.shared.loginWithKakaoAccount { oauthToken, error in
                                
                                print("2")
                                
                                if let error = error {
                                    print(error)
                                } else {
                                    print("새로운 Login")
                                    
                                    // do something
                                    _ = oauthToken
                                    
                                    // 로그인 성공 시
                                    UserApi.shared.me { kuser, error in
                                        
                                        if let error = error {
                                            print("------KAKAO: user loading failed------")
                                            print(error)
                                        } else {
                                            
                                            guard let email = ((kuser?.kakaoAccount?.email)) else { return }
                                            guard let pw =  kuser?.id else {return}
                                            guard let name = ((kuser?.kakaoAccount?.profile?.nickname)) else { return }
                                            
                                            
                                            outputId = "kakao_" + email
                                            outputPassword = "kakao_" + String(describing: pw )
                                            outputName = name
                                            
                                            self.firebaseService.signIn(email: outputId, password: outputPassword).subscribe({ [weak self] single in
                                                switch single {
                                                case .completed:
                                                    completable(.completed)

                                                case .error(let err):
                                                    completable(.error(err))

                                                }
                                           
                                                
                                            }).disposed(by: self.disposeBag)
                                            
                                        }
                                    }
                                }
                                
                                
                                
                                
                            }
                        }
                        
                    } else {
                        print("토큰있음3")
                        UserApi.shared.me { kuser, _ in
                            guard let email = (kuser?.kakaoAccount?.email) else { return }
                            guard let pw =  kuser?.id else {return}
                            guard let name  = kuser?.kakaoAccount?.profile?.nickname else {return}
                            
                            print("카카오?")

                            outputId = "kakao_" + email
                            outputPassword = "kakao_" + String(describing: pw )
                            outputName = name
                            
                            self.firebaseService.signIn(email: outputId, password: outputPassword).subscribe({ [weak self] single in
                                switch single {
                                case .completed:
                                    print("complete")
                                    completable(.completed)

                                case .error(let err):
                                    completable(.error(err))

                                }
                           
                                
                            }).disposed(by: self.disposeBag)
                            
                        }
                        
                    }
                    
                    
                }
            } else {
                if UserApi.isKakaoTalkLoginAvailable() {
                    print("토큰있음 3")
                    UserApi.shared.loginWithKakaoTalk { oauthToken, error in
                        if let error = error {
                            print(error)
                        } else {
                            print("New Kakao Login")
                            
                            // do something
                            _ = oauthToken
                            
                            
                            
                            // 로그인 성공 시
                            UserApi.shared.me { kuser, error in
                                if let error = error {
                                    print("------KAKAO: user loading failed------")
                                    print(error)
                                } else {
                                    guard let email = ((kuser?.kakaoAccount?.email)) else { return }
                                    guard let pw =  kuser?.id else {return}
                                    guard let name = kuser?.kakaoAccount?.profile?.nickname else {return}
                                    
                                    outputId = "kakao_" + email
                                    outputPassword = "kakao_" + String(describing: pw )
                                    outputName = name
                                    
                                    self.firebaseService.signIn(email: outputId, password: outputPassword).subscribe({ [weak self] single in
                                        switch single {
                                        case .completed:
                                            completable(.completed)

                                        case .error(let err):
                                            completable(.error(err))

                                        }
                                   
                                        
                                    }).disposed(by: self.disposeBag)
                                        
                                    
                              
                                    
                                }
                            }
                            
                        }
                        
                    }
                } else {
                    UserApi.shared.loginWithKakaoAccount { oauthToken, error in
                        print("4")
                        
                        if let error = error {
                            print(error)
                        } else {
                            print("New Kakao Login")
                            
                            // do something
                            _ = oauthToken
                            // 로그인 성공 시
                            UserApi.shared.me { kuser, error in
                                if let error = error {
                                    print("------KAKAO: user loading failed------")
                                    print(error)
                                } else {
                                    
                                    guard let email = ((kuser?.kakaoAccount?.email)) else { return }
                                    guard let pw =  kuser?.id else {return}
                                    guard let name = kuser?.kakaoAccount?.profile?.nickname else {return}
                                    
                                    print("\(email) 이메일")
                                    
                                    outputId = "kakao_" + email
                                    outputPassword = "kakao_" + String(describing: pw )
                                    outputName = name
                                    
                                    self.firebaseService.signIn(email: outputId, password: outputPassword).subscribe({ [weak self] single in
                                        switch single {
                                        case .completed:
                                            completable(.completed)

                                        case .error(let err):
                                            completable(.error(err))

                                        }
                                   
                                        
                                    }).disposed(by: self.disposeBag)
                                    
                                }
                            }
                            
                            
                        }
                        
                    }
                    
                }
            }
            
            return Disposables.create()
        }
      
        
        
        
    }
    
    
    
    
    
    
    
}
