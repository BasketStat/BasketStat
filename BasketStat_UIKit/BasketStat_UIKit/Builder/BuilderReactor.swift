//
//  BuilderReactor.swift
//  BasketStat_UIKit
//
//  Created by 양승완 on 7/29/24.
//

import Foundation
import ReactorKit
import RxSwift
import UIKit
import FirebaseAuth

class BuilderReactor: Reactor {
    
    
    var disposeBag = DisposeBag()
    let provider: ServiceProviderProtocol

    enum Action {
        case viewWillAppear
        
        
        
    }
    
    enum Mutation {
     case none
        
    }
    
    struct State {
        var homeArr = [PlayerModel.init(nickname: "양승완", tall: "167", position: .C, weight: "67")]
        var awayArr = [PlayerModel]()
        
        
    }
    
    
    
    let initialState: State
    
    init(provider: ServiceProviderProtocol) {
        self.initialState = State()
        self.provider = provider
    }
    
    

    
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
            
        
        case .viewWillAppear: 
            return Observable.just(.none)
            
        }
        
        
    }
    
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        
       
        case .none:
            break
        }
        
        
        return newState
    }
    
    
    
}
