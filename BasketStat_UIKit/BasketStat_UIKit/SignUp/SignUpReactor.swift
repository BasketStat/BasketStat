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

    }
    
    enum Mutation {

        
    }
    
    struct State {
        var isPushed : Bool
        
        
    }
    
    let initialState: State = .init(isPushed: false)
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
            
            
            
        }
        
    }
    
 
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        
        return newState
    }
}
