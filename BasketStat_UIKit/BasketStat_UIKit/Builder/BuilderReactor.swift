//
//  BuilderReactor.swift
//  BasketStat_UIKit
//
//  Created by 양승완 on 7/29/24.
//

import Foundation
import ReactorKit
import RxSwift
import UIKit
import FirebaseAuth
import RxRelay

class BuilderReactor: Reactor {
    
    
    var disposeBag = DisposeBag()
    let provider: ServiceProviderProtocol
    
    

    enum Action {
        case viewDidLoad
        case homeArrRemove(Int)
        case awayArrRemove(Int) 
        
        case homeArrUpdate(Int)
        case awayArrUpdate(Int)
        
        case homeLogoTapped
        case awayLogoTapped
        
        
        
        
    }
    
    enum Mutation {
        case none
        case homeArrRemove(Int)
        case awayArrRemove(Int)
        
        case homeArrUpdate(Int)
        case awayArrUpdate(Int)
        
        case getPickData(PlayerModel)

        case homeLogoTapped
        case awayLogoTapped
        
        case setHomeArr([PlayerModel])
        case setAwayArr([PlayerModel])
        
        case setHomeValues(String,String)
        case setAwayValues(String,String)
      

    }
    
    struct State {
        
        var homeArr = [PlayerModel]()
        var awayArr = [PlayerModel]()
        
        var pushSearchView: Bool
        
        var searchViewMode: SearchViewMode?
        
        var pickedPlayModel: PlayerModel?
        
        var pickIdx: Int?
        
        var teamPickIdx: Int?
        
        var isHomeArr: Bool?
        
        var homeImg: URL?
        var awayImg: URL?
        
        var homeName: String
        var awayName: String
        
        
    }
    
    
    
    let initialState: State
    
    init(provider: ServiceProviderProtocol) {
        self.initialState = State( pushSearchView: false, homeName: "", awayName: "")
        self.provider = provider
    }
    
    
    let searchReactorPlayer = BehaviorSubject<PlayerModel?>(value: nil)
    let searchReactorTeam = BehaviorSubject<TeamModel?>(value: nil)

    
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
            
        case .viewDidLoad:
            
            return Observable.create {  ob in
                
                    self.searchReactorPlayer.subscribe(onNext: { [weak self] model in
                        guard let self, let model = model else { return }
                        ob.onNext(.getPickData(model))
                        
                    }).disposed(by: self.disposeBag)
                    
                   print("temaSearch")
                   self.searchReactorTeam.subscribe(onNext: { [weak self] model in
                       
                       guard let self, let model = model, let isHome = currentState.isHomeArr else { return }
                       
                       
                       
                       
                       self.provider.algoliaService.getObjects(objectsIDs: model.teamMembers).subscribe({ single in
                           
                           switch single {
                           case .success(let models):
                               
                               
                               if isHome {
                                   
                                   ob.onNext(.setHomeValues(model.teamImageUrl, model.teamName))
                                   ob.onNext(.setHomeArr(models))
                               } else {
                                   ob.onNext(.setAwayValues(model.teamImageUrl, model.teamName))
                                   ob.onNext(.setAwayArr(models))

                               }
                           case .failure(let err):
                               print("\(err) err")
                           }
                           
                           
                       }).disposed(by: self.disposeBag)
                       
                     
                       
                   }).disposed(by: self.disposeBag)
               
               
            
                return Disposables.create()

            }
            
            
            
            
            
        case .homeArrRemove(let index):
            return Observable.just(.homeArrRemove(index))
        case .awayArrRemove(let index):
            return Observable.just(.awayArrRemove(index))
        case .homeArrUpdate(let index):
            return Observable.just(.homeArrUpdate(index))
        case .awayArrUpdate(let index):
            return Observable.just(.awayArrUpdate(index))
        
      
        case .homeLogoTapped:
            return Observable.just(.homeLogoTapped)
            
        case .awayLogoTapped:
            return Observable.just(.awayLogoTapped)
        }
        
        
    }
    
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        
       
        case .none:
            break
        case .homeArrRemove(let index):
            newState.homeArr.remove(at: index)
        case .awayArrRemove(let index):
            newState.awayArr.remove(at: index)
        case .homeArrUpdate(let index):
            newState.searchViewMode = .playerSearch
            newState.pushSearchView = true
            newState.isHomeArr = true
            newState.pickIdx = index
        case .awayArrUpdate(let index):
            newState.searchViewMode = .playerSearch
            newState.pushSearchView = true
            newState.isHomeArr = false
            newState.pickIdx = index
        case .getPickData(let model):
            newState.pushSearchView = false
            guard let isHome = currentState.isHomeArr, let idx = currentState.pickIdx else {break}
            
            
            if isHome {

                newState.homeArr[idx] = model

            } else {

                newState.awayArr[idx] = model

            }
            
            
            
        case .homeLogoTapped:
            
            newState.isHomeArr = true
            newState.teamPickIdx = 0
            newState.searchViewMode = .teamSearch
            newState.pushSearchView = true

        case .awayLogoTapped:
            newState.isHomeArr = false
            newState.teamPickIdx = 1
            newState.searchViewMode = .teamSearch
            newState.pushSearchView = true

        case .setHomeArr(let arr):
            newState.pushSearchView = false

            newState.homeArr = arr
            
        case .setAwayArr(let arr):
            newState.pushSearchView = false

            newState.awayArr = arr
        case .setHomeValues(let url, let name):
            
            newState.pushSearchView = false
            newState.homeName = name
            newState.homeImg = URL(string: url)
            
            
            

        case .setAwayValues(let url, let name):
            newState.pushSearchView = false
            newState.awayName = name
            newState.awayImg = URL(string: url)
        }
        
        
        return newState
    }
    
   

    
    
}
