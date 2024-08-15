//
//  PlayerManager.swift
//  BasketStat_UIKit
//
//  Created by 김정원 on 8/15/24.
//

import Foundation
import UIKit

//// 데이터가 있을수도 있고 없을수도 있고
//
//struct PlayerStat {
//    let team: Team
//    let point: Int?
//    let ast: Int?
//    let reb: Int?
//    let blk: Int?
//    let stl: Int?
//    let foul: Int?
//    let to: Int?
//}
//
//// 처음에 유저 Uuid 와 백넘버를 매칭할 거
////
//struct PlayerRecord {
//
//    let backNumber : [UUID: Int] = [:]
//
//    var player: [Int: PlayerStat] {
//
//    }
//
//}

class PlayerManager {
    static let shared = PlayerManager()
    private init() { } // 외부에서 초기화 하지 못하도록
    
    private var players: [UUID: Player] = [:]
    private var numberToUUIDMap: [Int: UUID] = [:]
    
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
    
    
}
// backnumber 로 Player 를 먼저 찾자
// 

let a_GamePlayers: [Player] = [
    Player(id: UUID(uuidString: "a53e20ff-5154-40ee-8d86-7df87c0bbb15")!, number: 1, team: .A, stats: []),
    Player(id: UUID(uuidString: "e911ddf2-3894-4692-8054-b7e28e3b8906")!, number: 3, team: .A, stats: []),
    Player(id: UUID(uuidString: "6583328e-9583-4ebd-b18c-c01eb96beabf")!, number: 5, team: .A, stats: []),
    Player(id: UUID(uuidString: "cc37433d-b47d-422e-94ca-f66ca03467b6")!, number: 7, team: .A, stats: []),
    Player(id: UUID(uuidString: "3c8dd880-f5c0-4502-9ecc-387b3c30e405")!, number: 9, team: .A, stats: []),
]

let b_GamePlayers: [Player] = [
    Player(id: UUID(uuidString: "af616c8d-3911-424e-9130-36e516ef484c")!, number: 2, team: .B, stats: []),
    Player(id: UUID(uuidString: "8d3b2cc9-a098-41ba-af43-030dd537606c")!, number: 4, team: .B, stats: []),
    Player(id: UUID(uuidString: "d6e12aa3-24f3-47ca-8d95-4a95ef7f6ec8")!, number: 6, team: .B, stats: []),
    Player(id: UUID(uuidString: "27454dc8-6625-4571-b563-76d075f27420")!, number: 8, team: .B, stats: []),
    Player(id: UUID(uuidString: "c07411a1-81a9-4a0b-b94b-48128bb8544b")!, number: 10, team: .B, stats: [])
]

struct GamePlayerManager {

    let a_GamePlayers: [Player] = [
        Player(id: UUID(uuidString: "a53e20ff-5154-40ee-8d86-7df87c0bbb15")!, number: 1, team: .A, stats: []),
        Player(id: UUID(uuidString: "e911ddf2-3894-4692-8054-b7e28e3b8906")!, number: 3, team: .A, stats: []),
        Player(id: UUID(uuidString: "6583328e-9583-4ebd-b18c-c01eb96beabf")!, number: 5, team: .A, stats: []),
        Player(id: UUID(uuidString: "cc37433d-b47d-422e-94ca-f66ca03467b6")!, number: 7, team: .A, stats: []),
        Player(id: UUID(uuidString: "3c8dd880-f5c0-4502-9ecc-387b3c30e405")!, number: 9, team: .A, stats: []),
        Player(id: UUID(uuidString: "af616c8d-3911-424e-9130-36e516ef484c")!, number: 2, team: .B, stats: []),
        Player(id: UUID(uuidString: "8d3b2cc9-a098-41ba-af43-030dd537606c")!, number: 4, team: .B, stats: []),
        Player(id: UUID(uuidString: "d6e12aa3-24f3-47ca-8d95-4a95ef7f6ec8")!, number: 6, team: .B, stats: []),
        Player(id: UUID(uuidString: "27454dc8-6625-4571-b563-76d075f27420")!, number: 8, team: .B, stats: []),
        Player(id: UUID(uuidString: "c07411a1-81a9-4a0b-b94b-48128bb8544b")!, number: 10, team: .B, stats: [])
    ]
  
    var a_TeamPlayerNumber: [Int] {
        return a_GamePlayers.filter{ $0.team == .A}.map{ $0.number }
    }
    
    var b_TeamPlayerNumber: [Int] {
        return a_GamePlayers.filter{ $0.team == .B}.map{ $0.number }
    }
}
