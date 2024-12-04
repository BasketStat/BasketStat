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
        case pushPickPlayersVC(TeamModel)
        case btnFalse
        case resetAlert
    }
    
    struct State: Equatable {
        
        var playerArr: [PlayerModel] = []
        
        var alertText = ""
        
        var popView = false
        
        var teamArr: [TeamModel] = []
        
        var mode: SearchViewMode
        
        var pushPickPlayersVC = false
        
        var pickedTeamModel: TeamModel?
        
        var isHome: Bool?
        
        var resetAlert: Bool
        
        
        
        
        

    }
    
    let initialState: State
    
    init(provider: ServiceProviderProtocol, builderReactor: BuilderReactor, mode: SearchViewMode, isHome: Bool?) {
        self.initialState = State( mode: mode, isHome: isHome, resetAlert: false)
        self.provider = provider
        self.builderReactor = builderReactor
        
    }
    
    

    
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
            
        case .searchPlayerText(let searchText):
            return Observable.create { [weak self] ob in
                guard let self else {return Disposables.create()}
                self.provider.algoliaService.searchPlayers(searchText: searchText).subscribe(onSuccess: { [weak self] players in
                    var players = players
                    
                    
                    
//                    if let picked = UserDefaults.standard.stringArray(forKey: "picked") {
//                        for pick in picked {
//                            players = players.filter { $0.playerUid != pick }
//                        }
//
//                    }
                
                    
                    ob.onNext(.resultPlayerArr(players))

                    
                    
                }).disposed(by: self.disposeBag)
                return Disposables.create()

            }
        case .alertText(let alertText):
            return Observable.just(.alertText(alertText))
            
        case .playerAlertTapped(let model):
            
            guard let isHome = currentState.isHome else {return Observable.just(.popView)}
                if CustomUserDefault.shared.determinePick(num: currentState.alertText, isHome: isHome) {
                    var playerModel = model
                    playerModel.number = currentState.alertText
                    CustomUserDefault.shared.pushPicked(uid: playerModel.playerUid)
                    builderReactor.searchReactorPlayer.onNext(playerModel)
                    
               
                    CustomUserDefault.shared.setPickNum(nums: [currentState.alertText], isHome: isHome)
                    return Observable.just(.popView)
                } else {
                    return Observable.concat([
                        Observable.just(.resetAlert)
                        ,Observable.just(.btnFalse)
                    ])
                }
            
            
            
            
        case .searchTeamText(let searchText):

            return Observable.create { [weak self] ob in
                guard let self else {return Disposables.create()}
                self.provider.algoliaService.searchTeams(searchText: searchText).subscribe(onSuccess: { [weak self] models in
                    
                    ob.onNext(.resultTeamArr(models))
                    
                }).disposed(by: self.disposeBag)
                
                return Disposables.create()
            }
        case .teamAlertTapped(let model):
            
            
            
            return Observable.concat([
                Observable.just(.pushPickPlayersVC(model))
                ,Observable.just(.btnFalse)
            ])
     
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
            
        case .pushPickPlayersVC(let teamModel):
            newState.pickedTeamModel = teamModel
            newState.pushPickPlayersVC = true
        case .btnFalse:
            newState.pushPickPlayersVC = false
            newState.resetAlert = false
       
        case .resetAlert:
        
            newState.resetAlert = true
        }
        
        return newState
    }
    func getPushPickPlayersReactor() -> PickPlayersReactor {
        
        return PickPlayersReactor(provider: self.provider, teamModel: currentState.pickedTeamModel! )
    }
    
    
}
