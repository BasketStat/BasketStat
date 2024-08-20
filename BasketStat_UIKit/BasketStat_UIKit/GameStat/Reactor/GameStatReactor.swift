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
import CoreData

class GameStatReactor: Reactor {

    enum Action {
        case selectedPlayer(player: Player)
        case selectedStat(stat: Stat)
        case selectedCancleButton
        case selecedSaveButton
        case setSuccess(isSuccess: Bool) // 성공 여부를 설정하는 액션 추가
    }

    enum Mutation {
        case setSelectedPlayer(player: Player?)
        case setSelectedStat(stat: Stat?)
        case setSelectedCancle
        case updatePlayerStats
        case setSuccess(isSuccess: Bool) // 성공 여부를 처리하는 뮤테이션 추가
    }

    struct State {
        var currentPlayer: Player?  // 현재 선택된 Player 객체
        var previousPlayer: Player?
        var currentStat: Stat?  // 현재 선택된 Stat 상태
        var previousStat: Stat? // 이전에 선택된 Stat 상태
        var isSuccess: Bool = false // 성공 여부를 저장하는 상태 추가
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
        case .selecedSaveButton:
            return .just(.updatePlayerStats)
        case let .setSuccess(isSuccess):
            return .just(.setSuccess(isSuccess: isSuccess)) // 성공 여부 설정
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
        case .updatePlayerStats:
            if let currentPlayer = newState.currentPlayer, let currentStat = newState.currentStat {
                GamePlayerManager.shared.incrementStat(for: currentPlayer, stat: currentStat)
                switch currentStat {
                case .TwoPA:
                    if newState.isSuccess {
                        GamePlayerManager.shared.incrementStat(for: currentPlayer, stat: .TwoPM)
                    }
                case .ThreePA:
                    if newState.isSuccess {
                        GamePlayerManager.shared.incrementStat(for: currentPlayer, stat: .ThreePM)
                    }
                case .FreeThrowPA:
                    if newState.isSuccess {
                        GamePlayerManager.shared.incrementStat(for: currentPlayer, stat: .FreeThrowPM)
                    }
                default:
                    break
                }
                for player in GamePlayerManager.shared.gamePlayers {
                    print(player.description())  // 여기에서 모든 플레이어의 현재 상태를 출력
                }
                //print(GamePlayerManager.shared.gamePlayers.filter{$0.number == 32})
            }
            newState.previousPlayer = nil
            newState.previousStat = nil
            newState.currentStat = nil
            newState.currentPlayer = nil
        case let .setSuccess(isSuccess):
            newState.isSuccess = isSuccess // 성공 여부를 저장
        }
        return newState
    }
}
