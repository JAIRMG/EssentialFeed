//
//  FeedLoaderCacheImageDecoratorTests.swift
//  EssentialAppTests
//
//  Created by Jair Moreno Gaspar on 11/02/21.
//

import XCTest
import EssentialFeed
import EssentialApp

class FeedLoaderCacheImageDecoratorTests: XCTestCase, FeedImageLoaderTestCase {
    
    func test_init_doesNotLoadImageData() {
        let (_, loader) = makeSUT()

        XCTAssertTrue(loader.loadedURLs.isEmpty, "Expected no loaded URLs")
    }
    
    func test_loadImageData_loadsFromLoader() {
        let url = anyURL()
        let (sut, loader) = makeSUT()

        _ = sut.loadImageData(from: url) { _ in }

        XCTAssertEqual(loader.loadedURLs, [url], "Expected to load URL from loader")
    }
    
    func test_cancelLoadImageData_cancelsLoaderTask() {
        let url = anyURL()
        let (sut, loader) = makeSUT()

        let task = sut.loadImageData(from: url) { _ in }
        task.cancel()

        XCTAssertEqual(loader.cancelledURLs, [url], "Expected to cancel URL loading from loader")
    }
    
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
        
        func save(_ data: Data, for url: URL, completion: @escaping (FeedImageCache.Result) -> Void) {
            messages.append(.save(data))
            completion(.success(()))
        }
        
    }
}
