//
//  PlayerModel.swift
//  UITester
//
//  Created by 양승완 on 7/4/24.
//

import Foundation
import UIKit


struct PlayerModel: Codable, Equatable {
    
    var nickname: String
    var tall: Double
    var position: PositionType
    var weight: Double
    var profileImageUrl: String?
    
    enum PositionType: String, Codable {
        case PG = "PG"
        case SG = "SG"
        case SF = "SF"
        case PF = "PF"
        case C = "C"
      }
    
    
    
    
    
}
