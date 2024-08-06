//
//  ServicesProtocol.swift
//  BasketStat_UIKit
//
//  Created by 양승완 on 7/30/24.
//

import Foundation
protocol ServiceProviderProtocol: AnyObject {
    var kakaoService: KakaoServiceProtocol { get }
    var firebaseService: FirebaseServiceProtocol  { get }
    var googleService: GoogleServiceProtocol  { get }
    var algoliaService: AlgoliaServiceProtocol  { get }
}

final class ServiceProvider: ServiceProviderProtocol {
    lazy var kakaoService: KakaoServiceProtocol = KakaoService(provider: self)
    lazy var firebaseService: FirebaseServiceProtocol = FirebaseService(provider: self)
    lazy var googleService: GoogleServiceProtocol = GoogleService(provider: self)
    lazy var algoliaService: AlgoliaServiceProtocol = AlgoliaService(provider: self)

    
    
}
