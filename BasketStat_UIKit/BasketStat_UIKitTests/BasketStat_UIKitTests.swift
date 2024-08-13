//
//  BasketStat_UIKitTests.swift
//  BasketStat_UIKitTests
//
//  Created by 김정원 on 7/9/24.
//

import XCTest
import AlgoliaSearchClient
import Foundation
import BasketStat_UIKit
import RxSwift


final class BasketStat_UIKitTests: XCTestCase {
    
    
    var client: SearchClient!
    var index: Index!

    override func setUp() {
        super.setUp()
        // Algolia 클라이언트 및 인덱스 설정
        let client = SearchClient(appID: "BLGKJBV97I", apiKey: "60a08066359684298a6ae2d88b807cf8")
        index = client.index(withName: "BasketStat")
    }

    func testSearch() {
        let expectation = self.expectation(description: "Algolia search should complete")

        var query = Query("양승완")
        query.attributesToRetrieve = ["nickname", "tall"]

        index.search(query: query) { result in
            print("Search started")

            switch result {
            case .failure(let error):
                print("Search error: \(error.localizedDescription)")
                XCTFail("Search failed: \(error.localizedDescription)")
            case .success(let response):
                print("Search succeeded with response: \(response)")
                XCTAssertNotNil(response) // 또는 필요한 검증 수행
            }

            // 기대 충족
            expectation.fulfill()
        }

        // 일정 시간 동안 비동기 요청을 기다림
        waitForExpectations(timeout: 10) { error in
            if let error = error {
                print("Timeout error: \(error.localizedDescription)")
            }
        }
    }
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
           
          
    }
  
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
