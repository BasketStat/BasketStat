//
//  PlayerModel.swift
//  UITester
//
//  Created by 양승완 on 7/4/24.
//

import Foundation
import UIKit

let positionDic = [0:"PG", 1:"SG", 2:"SF", 3:"PF", 4:"C"]

struct PlayerModel: Codable, Equatable {
    
    var nickname: String
    var tall: String
    var position: PositionType
    var weight: String
    var profileImageUrl: String?
    
    enum PositionType: String, Codable {
        case PG = "PG"
        case SG = "SG"
        case SF = "SF"
        case PF = "PF"
        case C = "C"
      }
    
    
    
    
    
    
}
