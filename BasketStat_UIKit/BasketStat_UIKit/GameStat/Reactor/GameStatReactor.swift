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
        case selectedPoint(point: Point)
        case selectedStat(stat: Stat)
    }
    
    enum Mutation {
        case setSelectedPlayer(number: Int, button: UIButton)
        case setSelectedPoint(point: Point)
        case setSelectedStat(stat: Stat)
    }
    
    struct State {
        var currentPlayerNumber: Int = 0
        var selectedPlayerButton: UIButton?
        var previousSelectedPlayerButton: UIButton?
        var pointButton: UIButton?
        var players = [Int :Player]() // 번호로 플레이어 구분
        
    }
    
    let initialState: State = .init()
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
            
        case let .selectedPlayer(number, button):
                .just(.setSelectedPlayer(number: number, button: button))
        case let .selectedPoint(point):
                .just(.setSelectedPoint(point: point))
        case let .selectedStat(stat):
                .just(.setSelectedStat(stat: stat))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case let .setSelectedPlayer(number, button):
            newState.previousSelectedPlayerButton = newState.selectedPlayerButton
          
            if newState.previousSelectedPlayerButton == button {
                newState.selectedPlayerButton = nil
            } else {
                newState.selectedPlayerButton = button
            }
            
            newState.currentPlayerNumber = number
            return newState
        case let .setSelectedPoint(point):
            <#code#>
        case let .setSelectedStat(stat):
            <#code#>
        }
    }
    
    
}
