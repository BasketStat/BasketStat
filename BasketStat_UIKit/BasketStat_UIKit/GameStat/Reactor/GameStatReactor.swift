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
        case selectedPlayer(player: Player)
        case selectedStat(stat: Stat)
        case selectedCancleButton
    }

    enum Mutation {
        case setSelectedPlayer(player: Player?)
        case setSelectedStat(stat: Stat?)
        case setSelectedCancle
    }

    struct State {
        var currentPlayer: Player?  // 현재 선택된 Player 객체
        var previousPlayer: Player?
        var currentStat: Stat?  // 현재 선택된 Stat 상태
        var previousStat: Stat? // 이전에 선택된 Stat 상태
        var isCancle: Bool = false
    }

    let initialState = State()

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .selectedPlayer(player):
            return .just(.setSelectedPlayer(player: player))
        case let .selectedStat(stat):
            return .just(.setSelectedStat(stat: stat))
        case .selectedCancleButton:
            return .just(.setSelectedCancle)
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case let .setSelectedPlayer(player):
            newState.previousPlayer = state.currentPlayer // 이전 상태 저장
            newState.currentPlayer = player
        case let .setSelectedStat(stat):
            newState.previousStat = state.currentStat // 이전 상태 저장
            newState.currentStat = stat
        case .setSelectedCancle:
            newState.previousPlayer = nil
            newState.previousStat = nil
            newState.currentStat = nil
            newState.currentPlayer = nil
        }
        return newState
    }
}
