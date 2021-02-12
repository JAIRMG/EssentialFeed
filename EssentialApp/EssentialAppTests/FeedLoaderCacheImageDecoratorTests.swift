//
//  FeedLoaderCacheImageDecoratorTests.swift
//  EssentialAppTests
//
//  Created by Jair Moreno Gaspar on 11/02/21.
//

import XCTest
import EssentialFeed

class FeedLoaderCacheImageDecorator: FeedImageDataLoader {

    private let loader: FeedImageDataLoader
    
    init(decoratee: FeedImageDataLoader) {
        self.loader = decoratee
    }
    
    private struct Task: FeedImageDataLoaderTask {
        func cancel() {
            
        }
    }
    
    func loadImageData(from url: URL, completion: @escaping (FeedImageDataLoader.Result) -> Void) -> FeedImageDataLoaderTask {
        _ = loader.loadImageData(from: url, completion: completion)
        return Task()
    }
}

class FeedLoaderCacheImageDecoratorTests: XCTestCase, FeedLoaderTestCase {
    
    func test_load_deliversImageDataFeedOnSuccess() {
        let loader = FeedImageLoaderSpy()
        let sut = FeedLoaderCacheImageDecorator(decoratee: loader)
        let data = anyData()
        
        expect(sut, toCompleteWith: .success(data)) {
            loader.complete(with: data)
        }
    }
    
    func test_load_deliversErrorOnImageLoaderFailure() {
        let error = anyNSError()
        let loader = FeedImageLoaderSpy()
        let sut = FeedLoaderCacheImageDecorator(decoratee: loader)
        
        expect(sut, toCompleteWith: .failure(error)) {
            loader.complete(with: error)
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
