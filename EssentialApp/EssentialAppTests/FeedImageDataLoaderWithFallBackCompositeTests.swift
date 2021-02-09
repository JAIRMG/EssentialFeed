//
//  FeedImageDataLoaderWithFallBackCompositeTests.swift
//  EssentialAppTests
//
//  Created by Jair Moreno Gaspar on 08/02/21.
//

import XCTest
import EssentialFeed

class FeedImageDataLoaderWithFallBackComposite: FeedImageDataLoader {
    private let primaryLoader: FeedImageDataLoader
    
    init(primaryLoader: FeedImageDataLoader, fallbackLoader: FeedImageDataLoader) {
        self.primaryLoader = primaryLoader
    }
    
    private struct Task: FeedImageDataLoaderTask {
        func cancel() {
        }
    }
    
    func loadImageData(from url: URL, completion: @escaping (FeedImageDataLoader.Result) -> Void) -> FeedImageDataLoaderTask {
        return Task()
    }
}

class FeedImageDataLoaderWithFallBackCompositeTests: XCTestCase {
    
    func test_load_doesNotLoadImageUponCreation() {
        let primaryLoader = LoaderSpy()
        let fallbackLoader = LoaderSpy()
        
        _ = FeedImageDataLoaderWithFallBackComposite(primaryLoader: primaryLoader, fallbackLoader: fallbackLoader)
        
        XCTAssertTrue(primaryLoader.loadedURLs.isEmpty, "Expected no loaded URLs in the primary loader")
        XCTAssertTrue(fallbackLoader.loadedURLs.isEmpty, "Expected no loaded URLs in the fallback loader")
    }
    
    private class LoaderSpy: FeedImageDataLoader {
        
        private var messages: [(url: URL, completion: (FeedImageDataLoader.Result) -> Void)] = []
        
        var loadedURLs: [URL] {
            messages.map { $0.url }
        }
        
        private struct Task: FeedImageDataLoaderTask {
            func cancel() {}
        }
        
        func loadImageData(from url: URL, completion: @escaping (FeedImageDataLoader.Result) -> Void) -> FeedImageDataLoaderTask {
            messages.append((url, completion))
            return Task()
        }
    }
    
}
