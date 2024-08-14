//
//  GetData.swift
//  BasketStat_UIKit
//
//  Created by 양승완 on 8/14/24.
//

import Foundation



import Foundation
import AlgoliaSearchClient
import RxSwift

protocol DataServiceProtocol {
    var dataHandler: ((PlayerModel) -> ())? { get set }
}


final class DataService: BaseService, DataServiceProtocol {
    var dataHandler: ((PlayerModel) -> ())?
    
    
    
    
    
    
}
