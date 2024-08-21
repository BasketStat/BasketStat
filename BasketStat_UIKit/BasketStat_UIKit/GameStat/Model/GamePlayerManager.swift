//
//  GamePlayerManager.swift
//  BasketStat_UIKit
//
//  Created by 김정원 on 8/18/24.
//

import Foundation
import UIKit
import CoreData

//struct Player: Equatable {
//    let id: UUID
//    let number: Int
//    let team: TeamType
//    var stats: PlayerStat
//
//    static func == (lhs: Player, rhs: Player) -> Bool {
//        return lhs.id == rhs.id
//    }
//    
//    mutating func incrementStat(_ stat: Stat) {
//        switch stat {
//        case .TwoPM:
//            stats.two_pm += 1
//        case .ThreePM:
//            stats.three_pm += 1
//        case .FreeThrowPM:
//            stats.ft_pm += 1
//        case .AST:
//            stats.ast += 1
//        case .REB:
//            stats.reb += 1
//        case .BLK:
//            stats.blk += 1
//        case .STL:
//            stats.stl += 1
//        case .FOUL:
//            stats.foul += 1
//        case .Turnover:
//            stats.turnover += 1
//        case .TwoPA:
//            stats.two_pa += 1
//        case .ThreePA:
//            stats.three_pa += 1
//        case .FreeThrowPA:
//            stats.ft_pa += 1
//        }
//    }
//    
//    func description() -> String {
//        return """
//        | Player \(number)         (Team \(team))
//        | 2pa : \(stats.two_pa)    2pm : \(stats.two_pm)
//        | 3pa : \(stats.three_pa)  3pm : \(stats.three_pm)
//        | fta : \(stats.ft_pa)     ftm : \(stats.ft_pm)
//        | Points: \(stats.point)
//        | Assists: \(stats.ast)    Rebounds: \(stats.reb) | Blocks: \(stats.blk)
//        | Steals: \(stats.stl)     Fouls: \(stats.foul)   |Turnovers: \(stats.turnover)
//        ----------------------------------------
//        """
//    }
//}
//struct PlayerStat {
//    var two_pa = 0
//    var two_pm = 0
//    var three_pa = 0
//    var three_pm = 0
//    var ft_pa = 0
//    var ft_pm = 0
//    var ast: Int = 0
//    var reb: Int = 0
//    var blk: Int = 0
//    var stl: Int = 0
//    var foul: Int = 0
//    var turnover: Int = 0
//    
//    var point: Int {
//        return (two_pm * 2 + three_pm * 3 + ft_pm)
//    }
//}

import Foundation
import UIKit
import CoreData

class GamePlayerManager {
    static let shared = GamePlayerManager()

    // Core Data persistent container setup
    let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "GameStat")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error {
                fatalError("Unresolved error \(error)")
            }
        })
        return container
    }()
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    // 초기 데이터 설정
    func setupInitialPlayers() {
        let existingPlayers = fetchPlayers()
        
        // 이미 플레이어가 저장된 경우, 초기화를 건너뜁니다.
        if existingPlayers.isEmpty {
            let initialPlayers: [(UUID, Int16, TeamType)] = [
                (UUID(uuidString: "a53e20ff-5154-40ee-8d86-7df87c0bbb15")!, 10, .A),
                (UUID(uuidString: "e911ddf2-3894-4692-8054-b7e28e3b8906")!, 32, .A),
                (UUID(uuidString: "6583328e-9583-4ebd-b18c-c01eb96beabf")!, 51, .A),
                (UUID(uuidString: "cc37433d-b47d-422e-94ca-f66ca03467b6")!, 27, .A),
                (UUID(uuidString: "3c8dd880-f5c0-4502-9ecc-387b3c30e405")!, 49, .A),
                (UUID(uuidString: "af616c8d-3911-424e-9130-36e516ef484c")!, 62, .B),
                (UUID(uuidString: "8d3b2cc9-a098-41ba-af43-030dd537606c")!, 84, .B),
                (UUID(uuidString: "d6e12aa3-24f3-47ca-8d95-4a95ef7f6ec8")!, 06, .B),
                (UUID(uuidString: "27454dc8-6625-4571-b563-76d075f27420")!, 89, .B),
                (UUID(uuidString: "c07411a1-81a9-4a0b-b94b-48128bb8544b")!, 10, .B)
            ]
            
            for playerData in initialPlayers {
                createPlayer(id: playerData.0, number: playerData.1, team: playerData.2)
            }
        }
    }
    
    // CRUD operations for Core Data
    func createPlayer(id: UUID, number: Int16, team: TeamType) {
        let newPlayer = PlayerEntity(context: context)
        newPlayer.player = id
        newPlayer.team = team.rawValue // enum을 string으로 변환
        newPlayer.two_pa = 0
        newPlayer.two_pm = 0
        newPlayer.three_pa = 0
        newPlayer.three_pm = 0
        newPlayer.ft_pa = 0
        newPlayer.ft_pm = 0
        newPlayer.ast = 0
        newPlayer.reb = 0
        newPlayer.stl = 0
        newPlayer.blk = 0
        newPlayer.foul = 0
        newPlayer.turnover = 0
        newPlayer.number = number
        
        do {
            try context.save()
        } catch {
            print("Failed to save player: \(error)")
        }
    }
    
    func fetchPlayers() -> [PlayerEntity] {
        let fetchRequest: NSFetchRequest<PlayerEntity> = PlayerEntity.fetchRequest()
        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("Failed to fetch players: \(error)")
            return []
        }
    }
    
    func updatePlayer(player: PlayerEntity, stat: Stat) {
        switch stat {
        case .TwoPA:
            player.two_pa += 1
        case .TwoPM:
            player.two_pm += 1
        case .ThreePA:
            player.three_pa += 1
        case .ThreePM:
            player.three_pm += 1
        case .FreeThrowPA:
            player.ft_pa += 1
        case .FreeThrowPM:
            player.ft_pm += 1
        case .AST:
            player.ast += 1
        case .REB:
            player.reb += 1
        case .BLK:
            player.blk += 1
        case .STL:
            player.stl += 1
        case .FOUL:
            player.foul += 1
        case .Turnover:
            player.turnover += 1
        }

        do {
            try context.save()
        } catch {
            print("Failed to update player: \(error)")
        }
    }
    
    func deletePlayer(player: PlayerEntity) {
        context.delete(player)
        
        do {
            try context.save()
        } catch {
            print("Failed to delete player: \(error)")
        }
    }
    
    func deleteAllPlayers() {
        let players = fetchPlayers() // 기존에 저장된 모든 플레이어를 가져옴
        for player in players {
            context.delete(player) // 각 플레이어를 컨텍스트에서 삭제
        }
        
        do {
            try context.save() // 변경사항을 저장
        } catch {
            print("Failed to delete all players: \(error)")
        }
    }
}
