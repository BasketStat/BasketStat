//
//  TeamModel.swift
//  BasketStat_UIKit
//
//  Created by 양승완 on 8/16/24.
//

import Foundation

struct TeamDto: Codable, Equatable {
    var teamId: String
    var teamName: String
    var teamImageUrl: String
    var teamMembers: [String]
    
    
    
    
     func getModel() -> TeamModel {
 
         return TeamModel(teamId: self.teamId, teamName: self.teamName, teamImageUrl: self.teamImageUrl, teamMembers: self.teamMembers)
     }
    
    
    
}

struct TeamModel: Equatable {
    var teamId: String
    var teamName: String
    var teamImageUrl: String
    var teamMembers: [String]

    var pickedMemebers: [PlayerModel]?
    
   
    func getDto(profileImageUrl: String) -> TeamDto {

        return TeamDto(teamId: self.teamId, teamName: self.teamName, teamImageUrl: self.teamImageUrl, teamMembers: self.teamMembers)
    }
    
    
}
