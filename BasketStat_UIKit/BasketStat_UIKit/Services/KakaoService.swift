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
class KakaoService {
    
    static let shared = KakaoService()
    
    
    
    
    func kakaoLogin() {
        
        var outputId: String!
        var outputPassword: String!
        var outputName: String!
        
        
        if AuthApi.hasToken() {
            
            UserApi.shared.accessTokenInfo { _, error in
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
                                        
                                        
                                        
                                        
                                    }
                                }
                                
                                
                                
                            }
                        }
                        
                    } else {
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
                                        
                                        
                                    }
                                }
                            }
                            
                            
                            
                            
                        }
                    }
                    
                } else {
                    UserApi.shared.me { kuser, _ in
                        guard let email = (kuser?.kakaoAccount?.email) else { return }
                        guard let pw =  kuser?.id else {return}
                        guard let name  = kuser?.kakaoAccount?.profile?.nickname else {return}
                        
                        outputId = "kakao_" + email
                        outputPassword = "kakao_" + String(describing: pw )
                        outputName = name
                        
                    }
                    
                }
                
                
            }
        } else {
            if UserApi.isKakaoTalkLoginAvailable() {
                print("3")
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
                                
                                print("\(email)")
                                
                                outputId = "kakao_" + email
                                outputPassword = "kakao_" + String(describing: pw )
                                outputName = name
                                
                                
                            }
                        }
                        
                        
                    }
                    
                }
                
            }
        }
        
        
        
    }
    
    
    
    
    
    
    
}
