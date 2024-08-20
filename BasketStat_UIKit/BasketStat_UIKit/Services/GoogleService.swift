//
//  GoogleServices.swift
//  BasketStat_UIKit
//
//  Created by 양승완 on 7/29/24.
//

import Foundation
import FirebaseCore
import GoogleSignIn
import FirebaseAuth
import RxSwift


protocol GoogleServiceProtocol {
    func signIn(vc: UIViewController) -> Completable

}


final class GoogleService: BaseService, GoogleServiceProtocol {
    
    let disposeBag = DisposeBag()
    let firebaseService = FirebaseService(provider: ServiceProvider())
    
    func signIn(vc: UIViewController) -> Completable {
        
        return Completable.create { com in
            
            // 구글 인증
            guard let clientID = FirebaseApp.app()?.options.clientID else {
                com(.error(CustomError.CustomNil))
                return Disposables.create()
            }
            
            _ = GIDConfiguration(clientID: clientID)
            
            GIDSignIn.sharedInstance.signIn(withPresenting: vc) { result, error in
                
                if let error {
                    com(.error(error))
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
                                
                self.firebaseService.signInCredential(credential: credential).subscribe({ comp in
                    com(comp)
                }).disposed(by: self.disposeBag)
            }
            
            return Disposables.create()
        }
        
    
    }
}
