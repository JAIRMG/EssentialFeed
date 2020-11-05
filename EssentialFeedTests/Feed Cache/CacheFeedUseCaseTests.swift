//
//  CacheFeedUseCaseTests.swift
//  EssentialFeedTests
//
//  Created by Jair Moreno Gaspar on 04/11/20.
//  Copyright © 2020 Jair Moreno G. All rights reserved.
//

import XCTest

class LocalFeedLoader {
    let store: FeedStore
    
    init(store: FeedStore) {
        self.store = store
    }
}

class FeedStore {
    var deleteCacheFeedCallCount = 0
}



class CacheFeedUseCaseTests: XCTestCase {
    
    func test() {
        let store = FeedStore()
        _ = LocalFeedLoader(store: store)
        XCTAssertEqual(store.deleteCacheFeedCallCount, 0)
    }
    
}
