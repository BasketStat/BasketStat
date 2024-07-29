//
//  LoginReactor.swift
//  BasketStat_UIKit
//
//  Created by 양승완 on 7/29/24.
//

import Foundation
import ReactorKit
import RxSwift
import UIKit
import FirebaseAuth

class LoginReactor: Reactor {
    
    private let googleService = GoogleService()
    private let firebaseService = FirebaseService()
    private let kakaoService = KakaoService()
    var disposeBag = DisposeBag()
    
    enum Action {
        case appleLogin(OAuthCredential)
        case kakaoLogin
        case googleLogin(UIViewController)
    }
    
    enum Mutation {
        case loginSuccess
        case loginFailed
        
    }
    
    struct State {
        var isPushed : Bool
        
        
    }
    
    let initialState: State = .init(isPushed: false)
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .appleLogin(let credential):
            return Observable.create { observable in
                
                self.firebaseService.signInCredential(credential: credential).subscribe({ completable in
                    switch completable {
                    case .completed:
                        self.firebaseService.getPlayer().subscribe({ [weak self] result in
                            
                            switch result {
                            case.success(let model):
                                print("model")
                            case.failure(let err):
                                observable.onNext(.loginSuccess)
                                
                                
                                
                            }
                            
                        }).disposed(by: self.disposeBag)
                        
                        
                        
                    case .error(_):
                        observable.onNext(Mutation.loginFailed)
                        
                    }
                    
                    
                }).disposed(by: self.disposeBag)
                
                
                return Disposables.create()
            }
            
        case .kakaoLogin:
            return Observable.create { [weak self] observable in
                guard let self else { return Disposables.create() }
                self.kakaoService.kakaoLogin().subscribe({ completable in
                    switch completable {
                    case.completed:
                        print("appleLogin Success")
                        observable.onNext(Mutation.loginSuccess)
                    case .error(_):
                        observable.onNext(Mutation.loginFailed)
                        
                    }
                }).disposed(by: disposeBag)
                
                return Disposables.create()
            }
        case .googleLogin(let vc):
            
            return googleService.signIn(vc: vc).map { value -> Mutation in
                if value {
                    print("로그인 성공")
                    return Mutation.loginSuccess
                }
                else {
                    return Mutation.loginFailed
                }
                
            }
            
        }
        
        
    }
    
 
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .loginFailed:
            break
        case .loginSuccess:
            newState.isPushed = true
            
        }
        
        
        return newState
    }
}
