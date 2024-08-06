//
//  SearchReactor.swift
//  BasketStat_UIKit
//
//  Created by 양승완 on 7/29/24.
//

import Foundation
import ReactorKit
import RxSwift
import UIKit
import FirebaseAuth

class SearchReactor: Reactor {
    
    
    var disposeBag = DisposeBag()
    let provider: ServiceProviderProtocol

    enum Action {
        case searchText(String)
    }
    
    enum Mutation {
        case resultArr([PlayerModel])
    }
    
    struct State: Equatable {
        static func == (lhs: SearchReactor.State, rhs: SearchReactor.State) -> Bool {
            return lhs.playerArr == rhs.playerArr
        }
        
        var playerArr: [PlayerModel] = []

    }
    
    let initialState: State
    
    init(provider: ServiceProviderProtocol) {
        self.initialState = State()
        self.provider = provider
    }
    
    

    
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
            
        case .searchText(let searchText):
            print("searchText \(searchText)")
            return Observable.create { [weak self] ob in
                guard let self else {return Disposables.create()}
                self.provider.algoliaService.searchPlayers(searchText: searchText).subscribe(onSuccess: { models in
                    
                    ob.onNext(.resultArr(models))
                    
                }).disposed(by: self.disposeBag)
                return Disposables.create()

            }
        }
        
        
    }
    
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
      
        case .resultArr(let models):
            newState.playerArr = models
        }
        
        
        return newState
    }
    
    
    
}
