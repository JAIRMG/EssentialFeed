//
//  HTTPClientStub.swift
//  EssentialAppTests
//
//  Created by Jair Moreno Gaspar on 17/02/21.
//

import EssentialFeed

class HTTPClientStub: HTTPClient {
    
    private let stub: (URL) -> HTTPClient.Result
    
    init(stub: @escaping (URL) -> HTTPClient.Result) {
        self.stub = stub
    }
    
    private class Task: HTTPClientTask {
        func cancel() {}
    }
    
    func get(from url: URL, completion: @escaping (HTTPClient.Result) -> Void) -> HTTPClientTask {
        completion(stub(url))
        return Task()
    }
    
    static var offline: HTTPClientStub {
        HTTPClientStub { _ in  .failure(NSError(domain: "offline", code: 0)) }
    }
    
    static func online(_ stub: @escaping (URL) -> (Data, HTTPURLResponse)) -> HTTPClientStub {
        HTTPClientStub { url  in
            .success(stub(url))
        }
    }
}
