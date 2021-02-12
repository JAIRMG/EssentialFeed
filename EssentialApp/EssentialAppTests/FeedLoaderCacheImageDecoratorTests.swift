//
//  FeedLoaderCacheImageDecoratorTests.swift
//  EssentialAppTests
//
//  Created by Jair Moreno Gaspar on 11/02/21.
//

import XCTest
import EssentialFeed

protocol FeedImageCache {
    typealias SaveResult = Result<Void, Swift.Error>
    
    func save(_ data: Data, for url: URL, completion: @escaping (SaveResult) -> Void)
}

class FeedLoaderCacheImageDecorator: FeedImageDataLoader {

    private let loader: FeedImageDataLoader
    private let cache: FeedImageCache
    
    init(decoratee: FeedImageDataLoader, cache: FeedImageCache) {
        self.loader = decoratee
        self.cache = cache
    }
    
    private struct Task: FeedImageDataLoaderTask {
        func cancel() {
            
        }
    }
    
    func loadImageData(from url: URL, completion: @escaping (FeedImageDataLoader.Result) -> Void) -> FeedImageDataLoaderTask {
        _ = loader.loadImageData(from: url, completion: { [weak self] result in
            completion(result.map { data in
                self?.cache.save(data, for: url) { _ in }
                return data
            })
        })
        return Task()
    }
}

class FeedLoaderCacheImageDecoratorTests: XCTestCase, FeedLoaderTestCase {
    
    func test_load_deliversImageDataFeedOnSuccess() {
        let (sut, loader) = makeSUT()
        let data = anyData()
        
        expect(sut, toCompleteWith: .success(data)) {
            loader.complete(with: data)
        }
    }
    
    func test_load_deliversErrorOnImageLoaderFailure() {
        let error = anyNSError()
        let (sut, loader) = makeSUT()
        
        expect(sut, toCompleteWith: .failure(error)) {
            loader.complete(with: error)
        }
    }
    
    func test_load_cachesFeedImageOnLoaderSuccess() {
        let cache = CacheImageSpy()
        let data = anyData()
        let (sut, loader) = makeSUT(cache: cache)
        
        expect(sut, toCompleteWith: .success(data)) {
            loader.complete(with: data)
        }
        
        XCTAssertEqual(cache.messages, [.save(data)], "Expected data cached on loader success")
    }
    
    func test_load_doesNotcacheFeedImageOnLoaderFailure() {
        let cache = CacheImageSpy()
        let (sut, loader) = makeSUT(cache: cache)
        let error = anyNSError()
        
        expect(sut, toCompleteWith: .failure(error)) {
            loader.complete(with: error)
        }
        
        XCTAssertTrue(cache.messages.isEmpty, "Expect to not cache data after loader failure")
    }
    
    // MARK: - Helpers
    
    private func makeSUT(cache: CacheImageSpy = .init(), file: StaticString = #file, line: UInt = #line) -> (sut: FeedImageDataLoader, loader: FeedImageLoaderSpy) {
        let loader = FeedImageLoaderSpy()
        let sut = FeedLoaderCacheImageDecorator(decoratee: loader, cache: cache)
        trackForMemoryLeaks(instance: loader, file: file, line: line)
        trackForMemoryLeaks(instance: sut, file: file, line: line)
        return (sut, loader)
    }
    
    private class CacheImageSpy: FeedImageCache {
        
        private(set) var messages: [Messages] = []
        
        enum Messages: Equatable {
            case save(Data)
        }
        
        func save(_ data: Data, for url: URL, completion: @escaping (SaveResult) -> Void) {
            messages.append(.save(data))
            completion(.success(()))
        }
        
    }
    
    private class FeedImageLoaderSpy: FeedImageDataLoader {
        
        private var messages: [(url: URL, completion: (FeedImageDataLoader.Result) -> Void)] = []
        
        private struct Task: FeedImageDataLoaderTask {
            func cancel() {
                
            }
        }
        
        func loadImageData(from url: URL, completion: @escaping (FeedImageDataLoader.Result) -> Void) -> FeedImageDataLoaderTask {
            messages.append((url, completion))
            return Task()
        }
        
        func complete(with data: Data, at index: Int = 0) {
            messages[index].completion(.success(data))
        }
        
        func complete(with error: Error, at index: Int = 0) {
            messages[index].completion(.failure(error))
        }
        
    }
    
    private func expect(_ sut: FeedImageDataLoader, toCompleteWith expectedResult: (FeedImageDataLoader.Result), when action: () -> Void, file: StaticString = #file, line: UInt = #line) {
        let exp = expectation(description: "Wait for load completion")

        _ = sut.loadImageData(from: anyURL()) { receivedResult in
            switch (receivedResult, expectedResult) {
            case let (.success(receivedFeed), .success(expectedFeed)):
                XCTAssertEqual(receivedFeed, expectedFeed, file: file, line: line)

            case (.failure, .failure):
                break

            default:
                XCTFail("Expected \(expectedResult), got \(receivedResult) instead", file: file, line: line)
            }

            exp.fulfill()
        }

        action()

        wait(for: [exp], timeout: 1.0)
    }
    
}
