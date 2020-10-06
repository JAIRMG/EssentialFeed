//
//  EsentialFeedTests.swift
//  EsentialFeedTests
//
//  Created by Jair Moreno G on 30/09/20.
//  Copyright © 2020 Jair Moreno G. All rights reserved.
//

import XCTest
import EssentialFeed

class RemoteFeedLoaderTests: XCTestCase {

    func test_init_doesNotRequestDataFromURL() {
        let (_, client) = makeSut()
        
        XCTAssertTrue(client.requestedURLs.isEmpty)
    }
    
    func test_requestsDataFromURL() {
        let url = URL(string: "https://a-given-url.com")!
        let (sut, client) = makeSut(url: url)
        
        sut.load { _ in }
        
        XCTAssertEqual(client.requestedURLs, [url])
        
    }
    
    func test_loadTwice_requestsDataFromURLTwice() {
        let url = URL(string: "https://a-given-url.com")!
        let (sut, client) = makeSut(url: url)
        
        sut.load { _ in }
        sut.load { _ in }

        
        XCTAssertEqual(client.requestedURLs, [url, url])
        
    }
    
    func test_load_deliversErrorOnClientError() {
        let (sut, client) = makeSut()
        
        var capturedErrors = [RemoteFeedLoader.Error]()
        sut.load {
            capturedErrors.append($0)
        }
        
        let error = NSError(domain: "", code: 0)
        client.complete(with: error)
        
        XCTAssertEqual(capturedErrors, [.connectivity])
        
    }
    
    func test_load_deliversHTTPErrorOnDataError() {
         let (sut, client) = makeSut()
        let url = URL(string: "https://a-given-url.com")!
        
         var capturedErrors = [RemoteFeedLoader.Error]()
         sut.load {
             capturedErrors.append($0)
         }
         
        client.complete(with: 400)
         
         XCTAssertEqual(capturedErrors, [.invalidData])
         
     }
    
    // MARK: - Helpers
    private func makeSut(url: URL = URL(string: "https://a-url.com")!) -> (sut: RemoteFeedLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteFeedLoader(url: url, client: client)
        return (sut, client)
        
    }
     
    private class HTTPClientSpy: HTTPClient {
        private var messages = [(url: URL, completion: (Error?, HTTPURLResponse?) -> Void)]()
        
        var requestedURLs: [URL] {
            messages.map { $0.url }
        }
        
        func get(from url: URL, completion: @escaping (Error?, HTTPURLResponse?) -> Void) {
            messages.append((url, completion))
        }
        
        func complete(with error: Error, at index: Int = 0) {
            messages[index].completion(error, nil)
        }
        
        func complete(with statusCode: Int, at index: Int = 0) {
            let response = HTTPURLResponse(url: requestedURLs[index],
                                           statusCode: statusCode,
                                           httpVersion: nil,
                                           headerFields: nil)
            messages[index].completion(nil, response)
        }
    }
}
