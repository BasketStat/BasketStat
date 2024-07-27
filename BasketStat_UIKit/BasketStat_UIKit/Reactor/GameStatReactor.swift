//
//  GameStatReactor.swift
//  BasketStat_UIKit
//
//  Created by 김정원 on 7/16/24.
//

import Foundation
import ReactorKit
import RxSwift

class GameStatReactor: Reactor {
    
    enum Action {
        case selectedPlayer(Int)
    }
    
    enum Mutation {
        case setPlayer(Int)
    }
    
    struct State {
        var currentPlayerNumber: Int = 0
        var players = [Int :Player]() // 번호로 플레이어 구분
        
    }
    
    let initialState: State = .init()
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {

        case let .selectedPlayer(number):
                .just(.setPlayer(number))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case let .setPlayer(number):
            
        }
        return newState
    }
}

