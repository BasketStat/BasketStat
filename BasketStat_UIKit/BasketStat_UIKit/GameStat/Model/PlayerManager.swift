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

struct GamePlayerManager {
    static let shared = GamePlayerManager()

    let gamePlayers: [Player] = [
        Player(id: UUID(uuidString: "a53e20ff-5154-40ee-8d86-7df87c0bbb15")!, number: 10, team: .A, stats: []),
        Player(id: UUID(uuidString: "e911ddf2-3894-4692-8054-b7e28e3b8906")!, number: 32, team: .A, stats: []),
        Player(id: UUID(uuidString: "6583328e-9583-4ebd-b18c-c01eb96beabf")!, number: 51, team: .A, stats: []),
        Player(id: UUID(uuidString: "cc37433d-b47d-422e-94ca-f66ca03467b6")!, number: 27, team: .A, stats: []),
        Player(id: UUID(uuidString: "3c8dd880-f5c0-4502-9ecc-387b3c30e405")!, number: 49, team: .A, stats: []),
        Player(id: UUID(uuidString: "af616c8d-3911-424e-9130-36e516ef484c")!, number: 62, team: .B, stats: []),
        Player(id: UUID(uuidString: "8d3b2cc9-a098-41ba-af43-030dd537606c")!, number: 84, team: .B, stats: []),
        Player(id: UUID(uuidString: "d6e12aa3-24f3-47ca-8d95-4a95ef7f6ec8")!, number: 06, team: .B, stats: []),
        Player(id: UUID(uuidString: "27454dc8-6625-4571-b563-76d075f27420")!, number: 89, team: .B, stats: []),
        Player(id: UUID(uuidString: "c07411a1-81a9-4a0b-b94b-48128bb8544b")!, number: 10, team: .B, stats: [])
    ]
  
    var a_TeamPlayerNumbers: [Int] {
        return gamePlayers.filter { $0.team == .A }.map { $0.number }
    }
    
    var b_TeamPlayerNumbers: [Int] {
        return gamePlayers.filter { $0.team == .B }.map { $0.number }
    }

    func getPlayer(for team: TeamType, index: Int) -> Player {
        let players = team == .A ? a_TeamPlayerNumbers : b_TeamPlayerNumbers
        return gamePlayers.filter { $0.team == team }[index]
    }
    
    func createPlayerButton(for player: Player) -> UIButton {
        return UIButton.createPlayerButton(backNumber: player.number)
    }
    
    func getPlayerIndex(for team: TeamType, player: Player) -> Int? {
        let players = team == .A ? gamePlayers.filter { $0.team == .A } : gamePlayers.filter { $0.team == .B }
        return players.firstIndex { $0.id == player.id }
    }
    
    func createTeamPlayerButtons(for team: TeamType) -> [UIButton] {
        return GamePlayerManager.shared.gamePlayers
            .filter { $0.team == team }
            .map { GamePlayerManager.shared.createPlayerButton(for: $0) }
    }
}
