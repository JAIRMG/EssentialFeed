//
//  HTTPClientTests.swift
//  EssentialFeedTests
//
//  Created by Jair Moreno G on 09/10/20.
//  Copyright © 2020 Jair Moreno G. All rights reserved.
//

import XCTest


class URLSessionHTTPClient {
    let session: URLSession
    
    init(session: URLSession) {
        self.session = session
    }
    
    func get(from url: URL) {
        session.dataTask(with: url) { (_, _, _) in
            
        }
    }
    
}

class URLSessionHTTPClientTests: XCTestCase {

    func test_getFromURL_createDataTaskWithURL() {
        let url = URL(string: "http://a-url.com")!
        let session = URLSessionTaskSpy()
        let sut = URLSessionHTTPClient(session: session)
        
        sut.get(from: url)
        
        XCTAssertEqual(session.receivedURLs, [url])
    }
    
    
    // MARK: - Helpers
    
    private class URLSessionTaskSpy: URLSession {
        var receivedURLs: [URL] = []
        
        override func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
            receivedURLs.append(url)
            return FakeURLSessionDataTask()
        }
    }

    private class FakeURLSessionDataTask: URLSessionDataTask {
        
    }
    
}
