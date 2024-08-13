//
//  PlayerModel.swift
//  UITester
//
//  Created by 양승완 on 7/4/24.
//

import Foundation
import UIKit
import Kingfisher
let positionDic = [0:"PG", 1:"SG", 2:"SF", 3:"PF", 4:"C"]

struct PlayerDto: Codable, Equatable {
    
    var nickname: String
    var tall: String
    var position: PositionType
    var weight: String
    var profileImageUrl: String

    
    
     func getModel() -> PlayerModel {
         
        
        
         
         
         return PlayerModel(nickname: self.nickname, tall: self.tall, position: self.position, weight: self.weight, profileImageUrl: profileImageUrl)
     }
    
    
    
    
    
    
}
enum PositionType: String, Codable {
    case PG = "PG"
    case SG = "SG"
    case SF = "SF"
    case PF = "PF"
    case C = "C"
  }

struct PlayerModel: Equatable {
    var nickname: String
    var tall: String
    var position: PositionType
    var weight: String
    var profileImageUrl: String?
    var profileImage: UIImage?
    var number: String?

    
   
    func getDto(profileImageUrl: String) -> PlayerDto {

        return PlayerDto(nickname: self.nickname, tall: self.tall, position: self.position, weight: self.weight, profileImageUrl: profileImageUrl)
    }
    
    
}

