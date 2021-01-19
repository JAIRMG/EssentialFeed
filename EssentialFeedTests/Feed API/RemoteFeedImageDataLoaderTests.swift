//
//  RemoteFeedImageDataLoaderTests.swift
//  EssentialFeedTests
//
//  Created by Jair Moreno Gaspar on 18/01/21.
//  Copyright © 2021 Jair Moreno G. All rights reserved.
//

import XCTest
import EssentialFeed

class RemoteFeedImageDataLoader {
    init(client: Any) {
        
    }
}

class RemoteFeedImageDataLoaderTests: XCTestCase {
    
    func test_init_doesNotPerformAnyURLRequest() {
        let (_, client) = makeSUT()

        XCTAssertTrue(client.requestedURLs.isEmpty)
    }
    
    // MARK: - Helpers
    private func makeSUT(url: URL = AnyURL(), file: StaticString = #file, line: UInt = #line) -> (sut: RemoteFeedImageDataLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteFeedImageDataLoader(client: client)
        trackForMemoryLeaks(instance: sut, file: file, line: line)
        trackForMemoryLeaks(instance: client, file: file, line: line)
        return (sut, client)
    }
    
    private class HTTPClientSpy {
        var requestedURLs = [URL]()
    }
    
}
