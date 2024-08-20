//
//  Stat.swift
//  BasketStat_UIKit
//
//  Created by 김정원 on 7/28/24.
//

import Foundation

enum Stat: String,CaseIterable {
    case TwoPA = "2점슛"
    case ThreePA = "3점슛"
    case FreeThrowPA = "자유투"
    case TwoPM, ThreePM, FreeThrowPM = ""
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


