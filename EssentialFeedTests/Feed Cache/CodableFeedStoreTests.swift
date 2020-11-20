//
//  CodableFeedStoreTests.swift
//  EssentialFeedTests
//
//  Created by Jair Moreno Gaspar on 20/11/20.
//  Copyright © 2020 Jair Moreno G. All rights reserved.
//

import XCTest
import EssentialFeed

class CodableFeedStore {
    
    private struct Cache: Codable {
        let feed: [CodableFeedImage]
        let timestamp: Date
        
        var localFeed: [LocalFeedImage] {
            feed.map { $0.local }
        }
    }
    
    private struct CodableFeedImage: Codable {
        private let id: UUID
        private let description: String?
        private let location: String?
        private let url: URL
        
        init(_ image: LocalFeedImage) {
            self.id = image.id
            self.description = image.description
            self.location = image.location
            self.url = image.url
        }
        
        var local: LocalFeedImage {
            LocalFeedImage(id: id,
                           description: description,
                           location: location,
                           url: url)
        }
    }
    
    private let storeURL: URL
    
    init(storeURL: URL) {
        self.storeURL = storeURL
    }
    
    func retrieve(completion: @escaping FeedStore.RetrievalCompletion) {
        guard let data = try? Data(contentsOf: storeURL) else {
            return completion(.empty)
        }
        let decoder = JSONDecoder()
        let cache = try! decoder.decode(Cache.self, from: data)
        completion(.found(feed: cache.localFeed, timestamp: cache.timestamp))
    }
    
    func insert(_ feed: [LocalFeedImage], timestamp: Date, completion: @escaping FeedStore.InsertionCompletion) {
        let encoder = JSONEncoder()
        let cache = Cache(feed: feed.map(CodableFeedImage.init), timestamp: timestamp)
        let enconded = try! encoder.encode(cache)
        try! enconded.write(to: storeURL)
        completion(nil)
    }
}

class CodableFeedStoreTests: XCTestCase {

    override func tearDown() {
        super.tearDown()
        try? FileManager.default.removeItem(at: storeURL())
        
    }
    
    override func setUp() {
        super.setUp()
        try? FileManager.default.removeItem(at: storeURL())
        
    }
    
    
    func test_retrieve_deliversEmptyOnEmptyCache() {
        let sut = makeSUT()
        let exp = expectation(description: "Wait for cache retrieval")
        
        sut.retrieve { result in
            switch result {
            case.empty:
                break
            default:
                XCTFail("Expect empty result, got \(result) instead")
            }
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1.0)
    }
    
    func test_retrieve_hasNoSideEffectsOnEmptyCache() {
        let sut = makeSUT()
        let exp = expectation(description: "Wait for cache retrieval")
        
        sut.retrieve { firstResult in
            sut.retrieve { secondResult in
                
                switch (firstResult, secondResult) {
                case (.empty, .empty):
                    break
                default:
                    XCTFail("Expect empty result, got \(firstResult) and \(secondResult) instead")
                }
                exp.fulfill()
                
            }
        }
        
        wait(for: [exp], timeout: 1.0)
    }

    func test_retrieve_afterInsertingToEmptyCache_deliversInsertedValues() {
        let sut = makeSUT()
        let exp = expectation(description: "Wait for cache retrieval")
        let feed = uniqueImageFeed().local
        let timestamp = Date()
        
        sut.insert(feed, timestamp: timestamp) { insertionError in
            XCTAssertNil(insertionError, "Expected feed to be inserted successfully")
            sut.retrieve { result in
                
                switch result {
                case let .found(retrievedFeed, retrievedTimestamp):
                    XCTAssertEqual(feed, retrievedFeed)
                    XCTAssertEqual(timestamp, retrievedTimestamp)
                default:
                    XCTFail("Expect empty result, got \(result) instead")
                }
                exp.fulfill()
                
            }
        }
        
        wait(for: [exp], timeout: 1.0)
    }
    
    // MARK: - Helpers
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> CodableFeedStore {
        let sut = CodableFeedStore(storeURL: storeURL())
        trackForMemoryLeaks(instance: sut, file: file, line: line)
        return sut
    }
    
    private func storeURL() -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("image-feed.store")
    }
}
