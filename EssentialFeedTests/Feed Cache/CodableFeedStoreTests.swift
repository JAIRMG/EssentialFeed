//
//  CodableFeedStoreTests.swift
//  EssentialFeedTests
//
//  Created by Jair Moreno Gaspar on 20/11/20.
//  Copyright © 2020 Jair Moreno G. All rights reserved.
//

import XCTest
import EssentialFeed

class CodableFeedStore {
    func retrieve(completion: @escaping FeedStore.RetrievalCompletion) {
        completion(.empty)
    }
}

class CodableFeedStoreTests: XCTestCase {

    func test_retrieve_delviersEmptyOnEmptyCache() {
        let sut = CodableFeedStore()
        let exp = expectation(description: "Wait for cache retrieval")
        
        sut.retrieve { result in
            switch result {
            case.empty:
                break
            default:
                XCTFail("Expect empty result, got \(result) instead")
            }
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1.0)
    }

}
