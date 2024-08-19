//
//  Stat.swift
//  BasketStat_UIKit
//
//  Created by 김정원 on 7/28/24.
//

import Foundation

enum Stat: String,CaseIterable {
    case TwoPT = "2점슛"
    case ThreePT = "3점슛"
    case FreeThrow = "자유투"
    case AST = "AST"
    case REB = "REB"
    case BLK = "BLK"
    case STL = "STL"
    case FOUL = "FOUL"
    case Turnover = "TO"
}

enum TeamType {
    case A
    case B
}


