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
        case setTall
        case setPosition
        
        
        case pushBtn
        case btnEnable(Bool)
        
        

    }
    
    enum Mutation {
        case isPushed
        case setTall(Double)
        case setPosition(String)
        case btnEnable(Bool)
        
    }
    
    struct State {
        var isPushed : Bool
        var tall: Double?
        var position: String?
        var isLoginButtonEnabled: Bool {
            return position != nil && tall != nil
        }
        
    }
    
    let initialState: State = .init(isPushed: false)
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
            
            
            
        
        case .pushBtn:
            return .just(.isPushed)
        case .setTall:
            return .just(.isPushed)
        case .setPosition:
            return .just(.isPushed)
        case .btnEnable(let enable):
            return .just(.isPushed)
        }
         
        
    }
    
   
 
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        
        return newState
    }
}
