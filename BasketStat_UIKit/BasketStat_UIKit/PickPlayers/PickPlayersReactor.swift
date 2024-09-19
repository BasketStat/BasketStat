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


class PickPlayersReactor: Reactor {
    
    
    var disposeBag = DisposeBag()
    
    let provider: ServiceProviderProtocol
    
    enum Action {
        
        case viewWillAppear
        case pickPlayerNum(String)
        case pickFin(Int)
        case exception(Int)
        case popToBuilderVC
        
    }
    
    enum Mutation {
        
        case setPlayerArr([PlayerModel])
        case pickPlayerNum(String)
        case popToBuilderVC
    
        
    }
    
    struct State {
        
        var teamModel: TeamModel
        
        var playerArr: [PlayerModel] = []
        
        var playerNumber: String?
        
        var popToBuilderVC = false
        
        var pickedModels: [PlayerModel] = []
        
        
    }
    
    let initialState: State
    
    init(provider: ServiceProviderProtocol, teamModel: TeamModel) {
        self.initialState = State(teamModel: teamModel)
        self.provider = provider
        
    }
    
    
    
    
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
            
        case .viewWillAppear:
            return Observable.create { [weak self] ob in
                
                guard let self else { return Disposables.create() }
                
                
                self.provider.algoliaService.getObjects(objectsIDs: currentState.teamModel.teamMembers).subscribe{ res in
                    
                    switch res {
                    case.success(let models):
                        ob.onNext(.setPlayerArr(models))
                        
                        
                    case.failure(let err):
                        print(err)
                    }
                    
                    
                    
                }.disposed(by: disposeBag)
                
                return Disposables.create()
            }
            
            
        case .pickPlayerNum(let number):
            return Observable.just(.pickPlayerNum(number))
        case .pickFin(let index):
            var playerArr = currentState.playerArr
            var player = currentState.playerArr[index]
            player.number = currentState.playerNumber ?? ""
            player.isPicked = true
            playerArr[index] = player
            return Observable.just(.setPlayerArr(playerArr))
        case .exception(let index):
            var playerArr = currentState.playerArr
            var player = currentState.playerArr[index]
            player.number = ""
            player.isPicked = false
            playerArr[index] = player
            return Observable.just(.setPlayerArr(playerArr))
        case .popToBuilderVC:
            return Observable.just(.popToBuilderVC)
        }
    }
        
        func reduce(state: State, mutation: Mutation) -> State {
            var newState = state
            
            switch mutation {
                
            case .setPlayerArr(let models):
                newState.playerArr = models
                let filtered = models.filter { $0.isPicked }
                newState.teamModel.pickedMemebers =  filtered
                
                
            case .pickPlayerNum(let number):
                newState.playerNumber = number
          
            case .popToBuilderVC:
                let picked = currentState.teamModel.pickedMemebers ?? []
                let pickedUid = picked.map { $0.playerUid }
                CustomUserDefault.shared.pushArr(uids: pickedUid )
                
                newState.popToBuilderVC = true
                
            }
            
            
            
            return newState
        }
        
        
        
    
    
}
