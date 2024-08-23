//
//  AlgoliaService.swift
//  BasketStat_UIKit
//
//  Created by 양승완 on 8/6/24.
//

import Foundation
import AlgoliaSearchClient
import RxSwift

protocol AlgoliaServiceProtocol {
    func searchPlayers(searchText: String) -> Single<[PlayerModel]>
    func searchTeams(searchText: String) -> Single<[TeamModel]>
    func getObjects(objectsIDs: [String]) -> Single<[PlayerModel]>
}


final class AlgoliaService: BaseService, AlgoliaServiceProtocol {
   
    
    let client = SearchClient(appID: "BLGKJBV97I", apiKey: "60a08066359684298a6ae2d88b807cf8")
    
    func searchTeams(searchText: String) -> Single<[TeamModel]> {
        let index = client.index(withName: "BasketStat_Team")

    
        return Single.create { single in
            
            index.search(query: Query(searchText)) { result in
                
                
                switch result {
                case .failure(let error):
                    single(.failure(error))

                case .success(let response):
                    do {
                        
                        let teams: [TeamDto] = try response.extractHits()
                        single(.success(teams.map {
                            $0.getModel()
                        }))
                    } catch let error {
                        single(.failure(error))

                    }
                }
            }
            return Disposables.create()
        }
    }
    func searchPlayers(searchText: String) -> Single<[PlayerModel]> {
        let index = client.index(withName: "BasketStat")

        
        
        return Single.create { single in
            index.search(query: Query(searchText)) { result in
                
                
                switch result {
                case .failure(let error):
                    single(.failure(error))

                case .success(let response):
                    do {
                        
                        let players: [PlayerDto] = try response.extractHits()
                        single(.success(players.map {
                            $0.getModel()
                        }))
                    } catch let error {
                        single(.failure(error))

                    }
                }
            }
            return Disposables.create()
        }
       
    }
    
    func getObjects(objectsIDs:[String]) -> Single<[PlayerModel]> {
        let index = client.index(withName: "BasketStat")
        return Single.create { single in
            
            let objs: [ObjectID] = objectsIDs.map { ObjectID(rawValue: $0) }
         
            index.getObjects(withIDs: objs) { (result: Result<ObjectsResponse<PlayerDto>, Error>) in
                switch result {
                case .success(let objects):
                    
                    let models = objects.results.map { $0!.getModel() }
                    single(.success(models))
                    
                case .failure(let error):
                    single(.failure(error))
                }
            }
            
            return Disposables.create()
        }
        
    }
 
}
