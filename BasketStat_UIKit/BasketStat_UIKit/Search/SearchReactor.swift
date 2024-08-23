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

// ViewControllerMode enum 정의
enum SearchViewMode {
    case teamSearch
    case playerSearch
}

class SearchReactor: Reactor {
    
    
    var disposeBag = DisposeBag()
    
    let provider: ServiceProviderProtocol
    
    let builderReactor: BuilderReactor
    
 
    

    enum Action {
        case searchPlayerText(String)
        case searchTeamText(String)
        case alertText(String)
        
        
        case playerAlertTapped(PlayerModel)
        case teamAlertTapped(TeamModel)
    
    }
    
    enum Mutation {
        case resultPlayerArr([PlayerModel])
        case resultTeamArr([TeamModel])
        case alertText(String)
        case popView
    }
    
    struct State: Equatable {
  
        var playerArr: [PlayerModel] = []
        
        var alertText = ""
                
        var popView = false
        
        var teamArr: [TeamModel] = []
        
        var mode: SearchViewMode

        

    }
    
    let initialState: State
    
    init(provider: ServiceProviderProtocol, builderReactor: BuilderReactor, mode: SearchViewMode) {
        self.initialState = State( mode: mode)
        self.provider = provider
        self.builderReactor = builderReactor
    }
    
    

    
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
            
        case .searchPlayerText(let searchText):
            return Observable.create { [weak self] ob in
                guard let self else {return Disposables.create()}
                self.provider.algoliaService.searchPlayers(searchText: searchText).subscribe(onSuccess: { [weak self] models in
                    
                    ob.onNext(.resultPlayerArr(models))
                    
                }).disposed(by: self.disposeBag)
                return Disposables.create()

            }
        case .alertText(let alertText):
            return Observable.just(.alertText(alertText))
            
        case .playerAlertTapped(let model):
            
            var playerModel = model
            playerModel.number = currentState.alertText
            
            builderReactor.searchReactorPlayer.onNext(playerModel)
            
            
            return Observable.just(.popView)
            
        case .searchTeamText(let searchText):
            print("searchText \(searchText)")

            return Observable.create { [weak self] ob in
                guard let self else {return Disposables.create()}
                self.provider.algoliaService.searchTeams(searchText: searchText).subscribe(onSuccess: { [weak self] models in
                    
                    ob.onNext(.resultTeamArr(models))
                    
                }).disposed(by: self.disposeBag)
                return Disposables.create()

            }
        case .teamAlertTapped(let model):
            self.builderReactor.searchReactorTeam.onNext(model)
            
            
            return Observable.just(.popView)
        }
        
        
    }
    
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
      
        case .resultPlayerArr(let models):
            newState.playerArr = models
            
        case .resultTeamArr(let models):
            newState.teamArr = models
        
        case .popView:
            newState.popView.toggle()
        case .alertText(let text):
            newState.alertText = text
            
        }
        
        
        return newState
    }
    
    
    
}
