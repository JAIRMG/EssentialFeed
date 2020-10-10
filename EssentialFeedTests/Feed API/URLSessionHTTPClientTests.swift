//
//  HTTPClientTests.swift
//  EssentialFeedTests
//
//  Created by Jair Moreno G on 09/10/20.
//  Copyright © 2020 Jair Moreno G. All rights reserved.
//

import XCTest
import EssentialFeed

class URLSessionHTTPClient {
    let session: URLSession
    
    init(session: URLSession) {
        self.session = session
    }
    
    func get(from url: URL, completion: @escaping (HTTPClientResult) -> Void) {
        session.dataTask(with: url) { (_, _, error) in
            if let error = error {
                completion(.failure(error))
            }
        }.resume()
    }
    
}

class URLSessionHTTPClientTests: XCTestCase {
 
    func test_getFromURL_resumeDataTaskWithURL() {
        let url = URL(string: "http://a-url.com")!
        let dataTask = URLSessionDataTaskSpy()
        let session = URLSessionTaskSpy()
        session.stub(url: url, task: dataTask)
        
        let sut = URLSessionHTTPClient(session: session)
        
        sut.get(from: url) { _ in }
        
        XCTAssertEqual(dataTask.resumeCallCount, 1)
    }
    
    func test_getFromURL_completesWithError() {
        let url = URL(string: "http://a-url.com")!
        let dataTask = URLSessionDataTaskSpy()
        let session = URLSessionTaskSpy()
        let error = NSError(domain: "an error", code: 0)
        session.stub(url: url, error: error)
        
        let sut = URLSessionHTTPClient(session: session)
        
        let exp = expectation(description: "wait for completion")
        
        sut.get(from: url) { result in
            switch result {
            case .failure(let receivedError as NSError):
                XCTAssertEqual(receivedError, error)
            default:
                XCTFail("expected failure with \(error) but instead received \(result)")
            }
            
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1.0)
    }
    
    // MARK: - Helpers
    
    private class URLSessionTaskSpy: URLSession {
        var stubs: [URL: Stub] = [:]
        
        struct Stub {
            let task: URLSessionDataTask
            let error: Error?
        }
        
        func stub(url: URL, task: URLSessionDataTask = FakeURLSessionDataTask(), error: Error? = nil) {
            stubs[url] = Stub(task: task, error: error)
        }
        
        override func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
            guard let stub = stubs[url] else {
                fatalError("Stub must exist with task and maybe error")
            }
            completionHandler(nil, nil, stub.error)
            return stub.task
        }
    }

    private class FakeURLSessionDataTask: URLSessionDataTask {
        override func resume() {
            
        }
    }
    
    private class URLSessionDataTaskSpy: URLSessionDataTask {
        var resumeCallCount = 0
        
        override func resume() {
            resumeCallCount += 1
        }
    }
    
}
