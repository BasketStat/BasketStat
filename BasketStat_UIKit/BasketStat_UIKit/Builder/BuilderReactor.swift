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
        
        
    }
    
    enum Mutation {
        case none
        case homeArrRemove(Int)
        case awayArrRemove(Int)
        
        case homeArrUpdate(Int)
        case awayArrUpdate(Int)
        
        case getPickData(PlayerModel)

        
      

    }
    
    struct State {
        
        var homeArr = [PlayerModel.init(nickname: "양승완", tall: "167", position: .C, weight: "67")]
        var awayArr = [PlayerModel]()
        
        var pushSearchView: Bool
        
        var pickedPlayModel: PlayerModel?
        
        var pickIdx: Int?
        
        var isHomeArr: Bool?
        

    }
    
    
    
    let initialState: State
    
    init(provider: ServiceProviderProtocol) {
        self.initialState = State( pushSearchView: false)
        self.provider = provider
    }
    
    
    let searchReactorSubject = BehaviorSubject<PlayerModel?>(value: nil)

    
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
            
        case .viewDidLoad:
            
            return Observable.create {  ob in
                
               
                self.searchReactorSubject.subscribe(onNext: { [weak self] model in
                    guard let self, let model = model else { return }
                    ob.onNext(.getPickData(model))
                    
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
            newState.pushSearchView.toggle()
            newState.isHomeArr = true
            newState.pickIdx = index
        case .awayArrUpdate(let index):
            newState.pushSearchView.toggle()
            newState.isHomeArr = false
            newState.pickIdx = index
        case .getPickData(let model):
            newState.pushSearchView = false
            guard let isHome = currentState.isHomeArr, let idx = currentState.pickIdx else {break}
            
            
            if isHome {
                print("\(newState.homeArr)")

                newState.homeArr[idx] = model

            } else {
                print("no break away")

                newState.awayArr[idx] = model

            }
            
            
            
        }
        
        
        return newState
    }
    
   

    
    
}
