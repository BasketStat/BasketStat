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
        case viewWillAppear
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
        

    }
    
    
    
    let initialState: State
    
    init(provider: ServiceProviderProtocol) {
        self.initialState = State( pushSearchView: false)
        self.provider = provider
    }
    
    
    let searchReactorSubject = BehaviorSubject<PlayerModel?>(value: nil)

    
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
            
        case .viewWillAppear: 
            
            print("viewWillAppear")
            return Observable.create {  ob in
                
               
                self.searchReactorSubject.subscribe(onNext: { [weak self] val in
                    guard let self, let val = val else { return }
                    ob.onNext(.getPickData(val))
                    
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
            print("toggle")
            newState.pushSearchView.toggle()
        case .awayArrUpdate(let index):
            print("toggle")
            newState.pushSearchView.toggle()
        case .getPickData(let model):
            newState.pushSearchView = false
            print("model \(model)")
            //newState.pickedPlayModel = model
            break
        }
        
        
        return newState
    }
    
   

    
    
}
