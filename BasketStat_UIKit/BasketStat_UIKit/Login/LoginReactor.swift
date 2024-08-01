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
    
    let initialState: State
    let provider: ServiceProviderProtocol
    
    init(provider: ServiceProviderProtocol) {
        self.initialState = State(isPushed: false)
        self.provider = provider
    }
    
    

    
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .appleLogin(let credential):
            return Observable.create { observable in
                
                self.provider.firebaseService.signInCredential(credential: credential).subscribe({ [weak self] completable in
                    guard let self else {return}
                 
                    switch completable {
                    case.completed:
                        self.provider.firebaseService.getPlayer().subscribe({ result in
                            
                            switch result {
                            case.success(_):
                                print("model")
                            case.failure(_):
                                observable.onNext(.loginSuccess)
                                
                                
                                
                            }
                            
                        }).disposed(by: self.disposeBag)
                    case .error(let err):
                        observable.onNext(Mutation.loginFailed)
                    }
                    
                    
                }).disposed(by: self.disposeBag)
                
                
                return Disposables.create()
            }
            
        case .kakaoLogin:
            return Observable.create { [weak self] observable in
                guard let self else { return Disposables.create() }
                self.provider.kakaoService.kakaoLogin().subscribe({ completable in
                    switch completable {
                    case.completed:
                        observable.onNext(Mutation.loginSuccess)
                    case .error(_):
                        observable.onNext(Mutation.loginFailed)
                        
                    }
                }).disposed(by: disposeBag)
                
                return Disposables.create()
            }
        case .googleLogin(let vc):
            
            return provider.googleService.signIn(vc: vc).map { value -> Mutation in
                if value {
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
