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
    
    enum Action {
        case buildingPush
        case recordPush
        case settingPush
   
    }
    
    enum Mutation {
        case buildingPush
        case recordPush
        case settingPush
    }
    
    struct State {
        var buildingPush = false
        var recordPush = false
        var settingPush = false
        
    }
    
    let initialState: State = .init()
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
   
        case .buildingPush:
            return .just(.buildingPush)
        case .recordPush:
            return .just(.recordPush)
        case .settingPush:
            return .just(.settingPush)
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
            
        }
        return newState
    }
}
