//
//  PlayerManager.swift
//  BasketStat_UIKit
//
//  Created by 김정원 on 8/15/24.
//

import Foundation
import UIKit
class PlayerManager {
    static let shared = PlayerManager()
    private init() { } // 외부에서 초기화 하지 못하도록
    
    private var players: [UUID: Player] = [:]
    private var numberToUUIDMap: [Int: UUID] = [:]
    private var buttonToPlayerMap: [UIButton: UUID] = [:] // 버튼과 플레이어 매핑
    
    func addPlayer(_ player: Player) {
        players[player.id] = player
        numberToUUIDMap[player.number] = player.id
    }
    
    func findPlayer(byNumber number: Int) -> Player? {
        guard let uuid = numberToUUIDMap[number] else { return nil }
        return players[uuid]
    }
    
    func findUUID(byNumber number: Int) -> UUID? {
        return numberToUUIDMap[number]
    }
    
    func mapButtonToPlayer(button: UIButton, number: Int) {
        if let uuid = findUUID(byNumber: number) {
            buttonToPlayerMap[button] = uuid
        }
    }
    
    func findPlayer(byButton button: UIButton) -> Player? {
        guard let uuid = buttonToPlayerMap[button] else { return nil }
        return players[uuid]
    }
}

