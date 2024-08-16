//
//  Stat.swift
//  BasketStat_UIKit
//
//  Created by 김정원 on 7/28/24.
//

import Foundation
enum BasketButton {
    case player
    case point
    case stat
}
enum Point: String, CaseIterable {
    case TwoPT = "2점슛"
    case ThreePT = "3점슛"
    case FreeThrow = "자유투"
}

enum Stat: String,CaseIterable {
    case TwoPT = "2점슛"
    case ThreePT = "3점슛"
    case FreeThrow = "자유투"
    case AST = "AST"
    case REB = "REB"
    case BLK = "BLK"
    case STL = "STL"
    case FOUL = "FOUL"
    case TO = "TO"
}

enum TeamType {
    case A
    case B
}

//struct Player {
//    let id: UUID
//    let number: Int
//    var stats: [PlayerStat]
//    
//}
//// 데이터가 있을수도 있고 없을수도 있고
//
struct PlayerStat {
    let point: Int?
    let ast: Int?
    let reb: Int?
    let blk: Int?
    let stl: Int?
    let foul: Int?
    let to: Int?
}
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
