//
//  GameStatReactor.swift
//  BasketStat_UIKit
//
//  Created by 김정원 on 7/16/24.
//

import Foundation
import ReactorKit
import RxSwift
import UIKit

class MainReactor: Reactor {
    
    var disposeBag = DisposeBag()
    let provider: ServiceProviderProtocol

    init(provider: ServiceProviderProtocol) {
        self.initialState = State()
        self.provider = provider
    }
    enum Action {
        case buildingPush
        case recordPush
        case settingPush
   
    }
    
    enum Mutation {
        case buildingPush
        case recordPush
        case settingPush
        
        case failedSignOut

    }
    
    struct State {
        var buildingPush = false
        var recordPush = false
        var settingPush = false
        
        
    }
    
    var initialState: State = .init()
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
   
        case .buildingPush:
            return .just(.buildingPush)
        case .recordPush:
            return .just(.recordPush)
        case .settingPush:
            return Observable.create {  [weak self] ob in
                guard let self else { return Disposables.create()}
                
                self.provider.firebaseService.signOut().subscribe({ com in
                    switch com {
                    case .completed:
                        print("signOut")
                        ob.onNext(.settingPush)
                        
                    case .error(let err):
                        ob.onNext(.failedSignOut)
                        
                    }
                    
                }).disposed(by: self.disposeBag)
                
                return Disposables.create()
            }
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .buildingPush:
            newState.buildingPush.toggle()
        case .recordPush:
            newState.recordPush.toggle()
        case .settingPush:
            newState.settingPush.toggle()
        case .failedSignOut:
            break
        }
        return newState
    }
}
