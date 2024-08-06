//
//  SearchVC.swift
//  UITester
//
//  Created by 양승완 on 7/4/24.
//

import UIKit
import SnapKit
import ReactorKit
import AlgoliaSearchClient

class SearchVC: UIViewController, View {
    
    
    private let reactor = BuilderReactor(provider: ServiceProvider())
    var disposeBag = DisposeBag()
    
    
    
 
    override func viewDidLoad() {
        
    }
    
    func bind(reactor: SearchReactor) {
        //
    }
}
