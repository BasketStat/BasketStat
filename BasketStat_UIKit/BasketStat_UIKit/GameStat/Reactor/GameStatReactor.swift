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
        case selectedPoint(point: Point, button: UIButton)
        case selectedStat(stat: Stat, button: UIButton)
    }
    
    enum Mutation {
        case setSelectedPlayer(number: Int, button: UIButton)
        case setSelectedPoint(point: Point, button: UIButton)
        case setSelectedStat(stat: Stat, button: UIButton)
    }
    
    struct State {
        var currentPlayerNumber: Int = 0
        var playerButton: (UIButton?, UIButton?)
        var pointButton: (UIButton?, UIButton?)
        var statButton: (UIButton?, UIButton?)
        var button = StatButton()
        var players = [Int :Player]() // 번호로 플레이어 구분
        
    }
    
    let initialState: State = .init()
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
            
        case let .selectedPlayer(number, button):
                .just(.setSelectedPlayer(number: number, button: button))
        case let .selectedPoint(point, button):
                .just(.setSelectedPoint(point: point, button: button))
        case let .selectedStat(stat, button):
                .just(.setSelectedStat(stat: stat, button: button))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case let .setSelectedPlayer(number, button):
            newState.playerButton.0 = newState.playerButton.1
            newState.playerButton.1 = newState.playerButton.0 == button ? nil : button
            newState.currentPlayerNumber = number
            return newState
        case let .setSelectedPoint(point, button):
            newState.pointButton.0 = newState.pointButton.1
            newState.pointButton.1 = newState.pointButton.0 == button ? nil : button
            return newState
        case let .setSelectedStat(stat, button):
            newState.statButton.0 = newState.statButton.1
            newState.statButton.1 = newState.statButton.0 == button ? nil : button
            return newState
        }
    }
}