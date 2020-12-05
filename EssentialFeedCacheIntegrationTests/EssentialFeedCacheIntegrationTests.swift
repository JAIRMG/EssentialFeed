//
//  EssentialFeedCacheIntegrationTests.swift
//  EssentialFeedCacheIntegrationTests
//
//  Created by Jair Moreno Gaspar on 04/12/20.
//  Copyright © 2020 Jair Moreno G. All rights reserved.
//

import XCTest
import EssentialFeed

class EssentialFeedCacheIntegrationTests: XCTestCase {

    func test_load_deliversNoItemsOnEmptyCache() {
        let sut = makeSUT()
        
        let exp = expectation(description: "wait for load completion")
        sut.load { result in
            switch result {
            case let .success(imageFeed):
                XCTAssertEqual(imageFeed, [], "Expected empty feed")
            case let .failure(error):
                XCTFail("Expected successful feed result, got \(error) instead")
            }
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1.0)
    }
    
    // MARK: - Helpers
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> FeedLoader {
        let storeBundle = Bundle(for: CoreDataFeedStore.self)
        let storeURL = testSpecificURL()
        let store = try! CoreDataFeedStore(storeURL: storeURL, bundle: storeBundle)
        let sut = LocalFeedLoader(store: store, currentDate: Date.init)
        trackForMemoryLeaks(instance: store, file: file, line: line)
        trackForMemoryLeaks(instance: sut, file: file, line: line)
        return sut
    }
    
    private func testSpecificURL() -> URL {
        cachesDirectory().appendingPathComponent("\(type(of: self)).store")
    }
    
    private func cachesDirectory() -> URL {
        return FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
    }
}