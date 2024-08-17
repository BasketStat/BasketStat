//
//  Player.swift
//  BasketStat_UIKit
//
//  Created by 김정원 on 7/27/24.
//

import Foundation
import UIKit

//struct Player:Codable {
//    
//    var playerNumber: Int
//    
//    
//    
//}

struct Player: Equatable {
    let id: UUID
    let number: Int
    let team: TeamType
    var stats: [PlayerStat]

    static func == (lhs: Player, rhs: Player) -> Bool {
        return lhs.id == rhs.id
    }
}
//struct StatButton {
//    var newSelectedPlayerButton: UIButton?
//    var preSelectedPointButton: UIButton?
//    var newSelectedPointButton: UIButton?
//    var preSelectedStatButton: UIButton?
//    var newSelectedStatButton: UIButton?
//}
