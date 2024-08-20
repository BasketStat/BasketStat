//
//  GamePlayerManager.swift
//  BasketStat_UIKit
//
//  Created by 김정원 on 8/18/24.
//

import Foundation
import UIKit

struct Player: Equatable {
    let id: UUID
    let number: Int
    let team: TeamType
    var stats: PlayerStat

    static func == (lhs: Player, rhs: Player) -> Bool {
        return lhs.id == rhs.id
    }
    
    mutating func incrementStat(_ stat: Stat) {
        switch stat {
        case .TwoPM:
            stats.two_pm += 1
        case .ThreePM:
            stats.three_pm += 1
        case .FreeThrowPM:
            stats.ft_pm += 1
        case .AST:
            stats.ast += 1
        case .REB:
            stats.reb += 1
        case .BLK:
            stats.blk += 1
        case .STL:
            stats.stl += 1
        case .FOUL:
            stats.foul += 1
        case .Turnover:
            stats.turnover += 1
        case .TwoPA:
            stats.two_pa += 1
        case .ThreePA:
            stats.three_pa += 1
        case .FreeThrowPA:
            stats.ft_pa += 1
        }
    }
    
    func description() -> String {
            return """
            Player \(number)        | (Team \(team)):
            ------------------------------------------------------------------------------
            2pa : \(stats.two_pa)   | 2pm : \(stats.two_pm)
            3pa : \(stats.three_pa) | 3pm : \(stats.three_pm)
            fta : \(stats.ft_pa)    | ftm : \(stats.ft_pm)
            ------------------------------------------------------------------------------
            Points: \(stats.point)  |
            Assists: \(stats.ast)   | Rebounds: \(stats.reb) | Blocks: \(stats.blk)
            Steals: \(stats.stl)    | Fouls: \(stats.foul)   |Turnovers: \(stats.turnover)
            """
        }
}
struct PlayerStat {
    var two_pa = 0
    var two_pm = 0
    var three_pa = 0
    var three_pm = 0
    var ft_pa = 0
    var ft_pm = 0
    var point: Int {
        return (two_pm * 2 + three_pm * 3 + ft_pm)
    }
    var ast: Int = 0
    var reb: Int = 0
    var blk: Int = 0
    var stl: Int = 0
    var foul: Int = 0
    var turnover: Int = 0
}


struct GamePlayerManager {
    static var shared = GamePlayerManager()

    var gamePlayers: [Player] = [
        Player(id: UUID(uuidString: "a53e20ff-5154-40ee-8d86-7df87c0bbb15")!, number: 10, team: .A, stats: PlayerStat()),
        Player(id: UUID(uuidString: "e911ddf2-3894-4692-8054-b7e28e3b8906")!, number: 32, team: .A, stats: PlayerStat()),
        Player(id: UUID(uuidString: "6583328e-9583-4ebd-b18c-c01eb96beabf")!, number: 51, team: .A, stats: PlayerStat()),
        Player(id: UUID(uuidString: "cc37433d-b47d-422e-94ca-f66ca03467b6")!, number: 27, team: .A, stats: PlayerStat()),
        Player(id: UUID(uuidString: "3c8dd880-f5c0-4502-9ecc-387b3c30e405")!, number: 49, team: .A, stats: PlayerStat()),
        Player(id: UUID(uuidString: "af616c8d-3911-424e-9130-36e516ef484c")!, number: 62, team: .B, stats: PlayerStat()),
        Player(id: UUID(uuidString: "8d3b2cc9-a098-41ba-af43-030dd537606c")!, number: 84, team: .B, stats: PlayerStat()),
        Player(id: UUID(uuidString: "d6e12aa3-24f3-47ca-8d95-4a95ef7f6ec8")!, number: 06, team: .B, stats: PlayerStat()),
        Player(id: UUID(uuidString: "27454dc8-6625-4571-b563-76d075f27420")!, number: 89, team: .B, stats: PlayerStat()),
        Player(id: UUID(uuidString: "c07411a1-81a9-4a0b-b94b-48128bb8544b")!, number: 10, team: .B, stats: PlayerStat())
    ]
  
    mutating func incrementStat(for player: Player, stat: Stat) {
        if let index = gamePlayers.firstIndex(where: { $0.id == player.id }) {
            gamePlayers[index].incrementStat(stat)
        }
    }
    
    var a_TeamPlayerNumbers: [Int] {
        return gamePlayers.filter { $0.team == .A }.map { $0.number }
    }
    
    var b_TeamPlayerNumbers: [Int] {
        return gamePlayers.filter { $0.team == .B }.map { $0.number }
    }

    func getPlayer(for team: TeamType, index: Int) -> Player {
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
