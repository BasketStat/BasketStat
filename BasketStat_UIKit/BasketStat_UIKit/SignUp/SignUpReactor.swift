//
//  SignUpReactor.swift
//  BasketStat_UIKit
//
//  Created by 양승완 on 7/30/24.
//

import Foundation
import ReactorKit
import RxSwift
import UIKit
import FirebaseAuth

class SignUpReactor: Reactor {
    
    
    var disposeBag = DisposeBag()
    
    enum Action {
        case pushBtn
        
        case setTall(String)
        case setWeight(String)
        case setNickname(String)
        case setPosition(Int)
        

    }
    
    enum Mutation {
        case isPushed
        
        case setTall(String)
        case setWeight(String)
        case setNickname(String)
        case setPosition(Int)
        
        
    }
    
    struct State {
        var isPushed : Bool
        
        var nickname: String = ""
        var tall: String = ""
        var weight: String = ""
        var position: Int?
        
        var isLoginButtonEnabled: Bool {
            
            return position != nil && !nickname.isEmpty && !tall.isEmpty && !weight.isEmpty
        }
        
    }
    
    let initialState: State = .init(isPushed: false)
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
            
            
            
            
        case .pushBtn:
            let playerModel = PlayerModel.init(nickname: initialState.nickname, tall: initialState.tall, position: PlayerModel.PositionType(rawValue: positionDic[initialState.position!]!)!  , weight: initialState.weight)
            
            provider.firebaseService.setPlayer()
            
            return .just(.isPushed)
            
            
        case .setTall(let tall):
            return .just(.setTall(tall))
            
        case .setPosition(let position):
            return .just(.setPosition(position))
            
        case .setWeight(let weight):
            return .just(.setWeight(weight))
            
        case .setNickname(let nickname):
            return .just(.setNickname(nickname))
        }
        
        
    }
    
    
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .setTall(let tall):
            newState.tall = tall
            
        case .isPushed:
            newState.isPushed.toggle()
        case .setPosition(let position):
            newState.position = position
            
        case .setWeight(let weight):
            newState.weight = weight
        case .setNickname(let nickname):
            newState.nickname = nickname
        }
        
        
        
        return newState
    }
}
