//
//  LoadFeedFromCacheUseCaseTests.swift
//  EssentialFeedTests
//
//  Created by Jair Moreno Gaspar on 12/11/20.
//  Copyright © 2020 Jair Moreno G. All rights reserved.
//

import XCTest
import EssentialFeed

class LoadFeedFromCacheUseCaseTests: XCTestCase {
    
    func test_init_DoesNotMessageStoreUponCreation() {
        let (_, store) = makeSUT()
        XCTAssertEqual(store.receivedMessages, [])
    }
    
    func test_load_loadRequestCacheRetrieval() {
        let (sut, store) = makeSUT()
        
        sut.load { _ in }
        
        XCTAssertEqual(store.receivedMessages, [.retrieve])
    }
    
    func test_load_loadFailsOnRetrievalError() {
        let (sut, store) = makeSUT()
        let retrievalError = anyNSError()
        let exp = expectation(description: "Wait for load completion")
        
        var receivedError: Error?
        sut.load { error in
            receivedError = error
            exp.fulfill()
        }
        
        store.completeRetrieval(with: retrievalError)
        
        wait(for: [exp], timeout: 1.0)
        XCTAssertEqual(receivedError as NSError?, retrievalError)
    }
    
    // MARK: - Helpers
    private func makeSUT(currentDate: @escaping () -> Date = Date.init, file: StaticString = #filePath, line: UInt = #line) -> (sut: LocalFeedLoader, store: FeedStoreSpy) {
        let store = FeedStoreSpy()
        let sut = LocalFeedLoader(store: store, currentDate: currentDate)
        trackForMemoryLeaks(instance: store, file: file, line: line)
        trackForMemoryLeaks(instance: sut, file: file, line: line)
        return (sut, store)
    }
    
    private func anyNSError() -> NSError {
        NSError(domain: "any error", code: 0)
    }
}
