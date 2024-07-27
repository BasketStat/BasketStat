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

class GameStatReactor: Reactor {
    
    enum Action {
        case selectedPlayer(number: Int, button: UIButton)
    }
    
    enum Mutation {
        case setSelectedPlayer(number: Int, button: UIButton)
    }
    
    struct State {
        var currentPlayerNumber: Int = 0
        var selectedButton: UIButton?
        var previousSelectedButton: UIButton?
        var players = [Int :Player]() // 번호로 플레이어 구분
        
    }
    
    let initialState: State = .init()
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
            
        case let .selectedPlayer(number, button):
                .just(.setSelectedPlayer(number: number, button: button))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case let .setSelectedPlayer(number, button):
            newState.previousSelectedButton = newState.selectedButton
          
            if newState.previousSelectedButton == button {
                newState.selectedButton = nil
            } else {
                newState.selectedButton = button
            }
            
            newState.currentPlayerNumber = number
            return newState
        }
    }
}
