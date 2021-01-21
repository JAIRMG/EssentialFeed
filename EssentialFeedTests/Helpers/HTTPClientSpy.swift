//
//  HTTPClientSpy.swift
//  EssentialFeedTests
//
//  Created by Jair Moreno Gaspar on 20/01/21.
//  Copyright © 2021 Jair Moreno G. All rights reserved.
//

import Foundation
import EssentialFeed

class HTTPClientSpy: HTTPClient {
    private var messages = [(url: URL, completion: (HTTPClient.Result) -> Void)]()
    
    private struct Task: HTTPClientTask {
        let callback: () -> Void
        func cancel() { callback() }
    }
    
    private(set) var cancelledURLs = [URL]()
    
    var requestedURLs: [URL] {
        return messages.map { $0.url }
    }
    
    func get(from url: URL, completion: @escaping (HTTPClient.Result) -> Void) -> HTTPClientTask {
        messages.append((url, completion))
        return Task { [weak self] in
            self?.cancelledURLs.append(url)
        }
    }
    
    func complete(with error: Error, at index: Int = 0) {
        messages[index].completion(.failure(error))
    }
    
    func complete(withStatusCode code: Int, data: Data, at index: Int = 0) {
        let response = HTTPURLResponse(
            url: requestedURLs[index],
            statusCode: code,
            httpVersion: nil,
            headerFields: nil
        )!
        messages[index].completion(.success((data, response)))
    }
    
    /*
     
     private struct Task: HTTPClientTask {
         func cancel() {}
     }
     
     private var messages = [(url: URL, completion: (HTTPClient.Result) -> Void)]()
     
     var requestedURLs: [URL] {
         messages.map { $0.url }
     }
     
     func get(from url: URL, completion: @escaping (HTTPClient.Result) -> Void) -> HTTPClientTask {
         messages.append((url, completion))
         return Task()
     }
     
     func complete(with error: Error, at index: Int = 0) {
         messages[index].completion(.failure(error))
     }
     
     func complete(with statusCode: Int, data: Data, at index: Int = 0) {
         let response = HTTPURLResponse(url: requestedURLs[index],
                                        statusCode: statusCode,
                                        httpVersion: nil,
                                        headerFields: nil)!
         messages[index].completion(.success((data, response)))
     }
     
     */
}
