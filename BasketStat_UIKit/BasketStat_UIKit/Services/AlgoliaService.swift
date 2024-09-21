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
        var query = Query(searchText)


        return Single.create { single in
            
            index.search(query: query ) { result in
                
                
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

        var query = Query(searchText)

        if let picked = UserDefaults.standard.stringArray(forKey: "picked") {
            var filtersString = ""
            for i in 0..<picked.count {
                if i != 0 {
                    
                    filtersString += " AND "
                }
                filtersString += "NOT objectID:\(picked[i])"
            }
            
            print("\(filtersString)  filterString")
            query.filters = filtersString


        }
        
        
        return Single.create { single in
            index.search(query: query) { result in
                
                
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
