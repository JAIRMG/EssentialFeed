//
//  LocalFeedImageDataLoaderTests.swift
//  EssentialFeedTests
//
//  Created by Jair Moreno Gaspar on 25/01/21.
//  Copyright © 2021 Jair Moreno G. All rights reserved.
//

import XCTest
import EssentialFeed

protocol FeedImageDataStore {
    func retrieve(dataForURL url: URL)
}

class LocalFeedImageDataLoader: FeedImageDataLoader {
    let store: FeedImageDataStore
    
    init(store: FeedImageDataStore) {
        self.store = store
    }
    
    private struct Task: FeedImageDataLoaderTask {
        func cancel() {
            
        }
    }
    
    func loadImageData(from url: URL, completion: @escaping (FeedImageDataLoader.Result) -> Void) -> FeedImageDataLoaderTask {
        
        store.retrieve(dataForURL: url)
        return Task()
    }
    
}

class LocalFeedImageDataLoaderTests: XCTestCase {
    
    func test_init_doesNotMessageStoreUponCreation() {
        let (_, store) = makeSUT()
        XCTAssertTrue(store.receivedMessages.isEmpty)
    }
    
    func test_loadImageDataFromURL_requestsStoredDataForURL() {
        let (sut, store) = makeSUT()
        let url = AnyURL()
        
        _ = sut.loadImageData(from: url) { _ in }
        
        XCTAssertEqual(store.receivedMessages, [.retrieve(dataFor: url)])
    }
    
    // MARK: - Helpers
    private func makeSUT(currentDate: @escaping () -> Date = Date.init, file: StaticString = #file, line: UInt = #line) -> (sut: LocalFeedImageDataLoader, store: StoreSpy) {
        let store = StoreSpy()
        let sut = LocalFeedImageDataLoader(store: store)
        trackForMemoryLeaks(instance: store, file: file, line: line)
        trackForMemoryLeaks(instance: sut, file: file, line: line)
        return (sut, store)
    }
    
    private class StoreSpy: FeedImageDataStore {
        private(set) var receivedMessages = [Message]()
        
        enum Message: Equatable {
            case retrieve(dataFor: URL)
        }
        
        func retrieve(dataForURL url: URL) {
            receivedMessages.append(.retrieve(dataFor: url))
        }
    }
}
