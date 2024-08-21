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
        case selectedPlayer(player: PlayerEntity)
        case selectedStat(stat: Stat)
        case selectedCancleButton
        case selecedSaveButton
        case setSuccess(isSuccess: Bool)
    }
    
    enum Mutation {
        case setSelectedPlayer(player: PlayerEntity?)
        case setSelectedStat(stat: Stat?)
        case setSelectedCancle
        case updatePlayerStats
        case setSuccess(Bool)
    }
    
    struct State {
        var currentPlayer: PlayerEntity?  // 현재 선택된 Player 객체
        var previousPlayer: PlayerEntity?
        var currentStat: Stat?  // 현재 선택된 Stat 상태
        var previousStat: Stat? // 이전에 선택된 Stat 상태
        var isSuccess: Bool = false
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
            return .just(.setSuccess(isSuccess))
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
                GamePlayerManager.shared.updatePlayer(player: currentPlayer, stat: currentStat)
                
                // 성공 여부에 따라 추가로 업데이트
                switch currentStat {
                case .TwoPA:
                    if newState.isSuccess {
                        GamePlayerManager.shared.updatePlayer(player: currentPlayer, stat: .TwoPM)
                    }
                case .ThreePA:
                    if newState.isSuccess {
                        GamePlayerManager.shared.updatePlayer(player: currentPlayer, stat: .ThreePM)
                    }
                case .FreeThrowPA:
                    if newState.isSuccess {
                        GamePlayerManager.shared.updatePlayer(player: currentPlayer, stat: .FreeThrowPM)
                    }
                default:
                    break
                }
                print("Player : \(currentPlayer)")
                // Core Data에서 모든 플레이어를 가져와 출력 (디버그용)
//                let allPlayers = GamePlayerManager.shared.fetchPlayers()
//                for player in allPlayers {
//                    print("Player \(2), Team: \(player.team), Stats: \(player)")
//                }
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
