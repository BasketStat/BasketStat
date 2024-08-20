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
    
    
}
