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
        case selectedStat(stat: Stat)
        case selectedCancleButton
    }

    enum Mutation {
        case setSelectedPlayer(number: Int, button: UIButton)
        case setSelectedStat(stat: Stat?)
        case setSelectedCancle
    }

    struct State {
        var currentPlayerNumber: Int = 0
        var playerButton: (UIButton?, UIButton?)
        var currentStat: Stat?  // 현재 선택된 Stat 상태
        var previousStat: Stat? // 이전에 선택된 Stat 상태
    }

    let initialState = State()

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .selectedPlayer(number, button):
            return .just(.setSelectedPlayer(number: number, button: button))
        case let .selectedStat(stat):
            return .just(.setSelectedStat(stat: stat))
        case .selectedCancleButton:
            return .just(.setSelectedCancle)
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case let .setSelectedPlayer(number, button):
            newState.playerButton.0 = newState.playerButton.1
            newState.playerButton.1 = newState.playerButton.0 == button ? nil : button
            newState.currentPlayerNumber = number
        case let .setSelectedStat(stat):
            newState.previousStat = state.currentStat // 이전 상태 저장
            newState.currentStat = stat
        case .setSelectedCancle:
            newState.previousStat = nil
            newState.currentStat = nil
        }
        return newState
    }
}
