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
        case homeArrRemove(Int)
        case awayArrRemove(Int) 
        
        case homeArrUpdate(Int)
        case awayArrUpdate(Int)
        
    }
    
    enum Mutation {
        case none
        case homeArrRemove(Int)
        case awayArrRemove(Int)
        
        case homeArrUpdate(Int)
        case awayArrUpdate(Int)
      

    }
    
    struct State: Equatable {
        
        var homeArr = [PlayerModel.init(nickname: "양승완", tall: "167", position: .C, weight: "67")]
        var awayArr = [PlayerModel]()
        
        var pushSearchView = false
        

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
            
        case .homeArrRemove(let index):
            return Observable.just(.homeArrRemove(index))
        case .awayArrRemove(let index):
            return Observable.just(.awayArrRemove(index))
        case .homeArrUpdate(let index):
            return Observable.just(.homeArrUpdate(index))
        case .awayArrUpdate(let index):
            return Observable.just(.awayArrUpdate(index))

        }
        
        
    }
    
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        
       
        case .none:
            break
        case .homeArrRemove(let index):
            newState.homeArr.remove(at: index)
        case .awayArrRemove(let index):
            newState.awayArr.remove(at: index)
        case .homeArrUpdate(let index):
            newState.pushSearchView = true
        case .awayArrUpdate(let index):
            newState.pushSearchView = true
        }
        
        
        return newState
    }
    
   

    
    
}
