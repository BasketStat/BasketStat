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
    
    let builderReactor: BuilderReactor
    
 

    enum Action {
        case searchText(String)
        case alertText(String)
        case alertTapped(PlayerModel)
    }
    
    enum Mutation {
        case resultArr([PlayerModel])
        case alertText(String)
        case popView
    }
    
    struct State: Equatable {
        static func == (lhs: SearchReactor.State, rhs: SearchReactor.State) -> Bool {
            return lhs.playerArr == rhs.playerArr
        }
        

        
        var playerArr: [PlayerModel] = []
        
        var alertText = ""
        
        var pickedModel: PlayerModel?
        
        var popView = false
        

    }
    
    let initialState: State
    
    init(provider: ServiceProviderProtocol, builderReactor: BuilderReactor) {
        self.initialState = State()
        self.provider = provider
        self.builderReactor = builderReactor
    }
    
    

    
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
            
        case .searchText(let searchText):
            return Observable.create { [weak self] ob in
                guard let self else {return Disposables.create()}
                self.provider.algoliaService.searchPlayers(searchText: searchText).subscribe(onSuccess: { [weak self] models in
                    
                    ob.onNext(.resultArr(models))
                    
                }).disposed(by: self.disposeBag)
                return Disposables.create()

            }
        case .alertText(let alertText):
            return Observable.just(.alertText(alertText))
            
        case .alertTapped(let model):
            
            print("alertTapped")
            var playerModel = model
            playerModel.number = currentState.alertText
            
            builderReactor.searchReactorSubject.onNext(playerModel)
            
            
            return Observable.just(.popView)
        }
        
        
    }
    
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
      
        case .resultArr(let models):
            newState.playerArr = models
        case .popView:
            newState.popView.toggle()
        case .alertText(let text):
            newState.alertText = text
            
        }
        
        
        return newState
    }
    
    
    
}
