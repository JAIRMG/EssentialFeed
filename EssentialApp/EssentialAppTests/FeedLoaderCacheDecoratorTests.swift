//
//  FeedLoaderCacheDecoratorTests.swift
//  EssentialAppTests
//
//  Created by Jair Moreno Gaspar on 09/02/21.
//

import XCTest
import EssentialFeed

class FeedLoaderCacheDecorator: FeedLoader {
    private let decoratee: FeedLoader

    init(decoratee: FeedLoader) {
        self.decoratee = decoratee
    }
    
    func load(completion: @escaping (FeedLoader.Result) -> Void) {
        decoratee.load(completion: completion)
    }
}

class FeedLoaderCacheDecoratorTests: XCTestCase, FeedLoaderTestCase {
    
    func test_load_deliversFeedOnSuccess() {
        let feed = uniqueFeed()
        let loader = FeedLoaderStub(result: .success(feed))
        let sut = makeSUT(decoratee: loader)
        
        expect(sut, toCompleteWith: .success(feed))
    }
    
    func test_load_deliversErrorOnLoaderFailure() {
        let error = anyNSError()
        let loader = FeedLoaderStub(result: .failure(error))
        let sut = makeSUT(decoratee: loader)
        
        expect(sut, toCompleteWith: .failure(error))
    }
    
    // MARK: - Helpers
    
    private func makeSUT(decoratee: FeedLoader, file: StaticString = #file, line: UInt = #line) -> FeedLoader {
        let sut = FeedLoaderCacheDecorator(decoratee: decoratee)
        trackForMemoryLeaks(instance: sut, file: file, line: line)
        return sut
    }

}
