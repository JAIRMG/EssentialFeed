//
//  RemoteFeedImageDataLoader.swift
//  EssentialFeed
//
//  Created by Jair Moreno Gaspar on 21/01/21.
//  Copyright © 2021 Jair Moreno G. All rights reserved.
//

import Foundation

public final class RemoteFeedImageDataLoader {
    private let client: HTTPClient
    
    private final class HTTPTaskWrapper: FeedImageDataLoaderTask {
        var wrapped: HTTPClientTask?
        private var completion: ((FeedImageDataLoader.Result) -> Void)?
        
        init(_ completion: @escaping (FeedImageDataLoader.Result) -> Void) {
            self.completion = completion
        }
        
        func complete(with result: FeedImageDataLoader.Result) {
            completion?(result)
        }
        
        func cancel() {
            preventFurtherCompletions()
            wrapped?.cancel()
        }
        
        private func preventFurtherCompletions() {
            completion = nil
        }
        
    }
    
    public init(client: HTTPClient) {
        self.client = client
    }
    
    public enum Error: Swift.Error {
        case invalidData
    }
    
    @discardableResult
    public func loadImageData(from url: URL, completion: @escaping (FeedImageDataLoader.Result) -> Void) -> FeedImageDataLoaderTask {
        let task = HTTPTaskWrapper(completion)
        task.wrapped =  client.get(from: url) { [weak self] result in
            guard self != nil else { return }
            switch result {
            case let .success((data, response)):
                if response.statusCode == 200, !data.isEmpty {
                    task.complete(with: .success(data))
                } else {
                    task.complete(with: .failure(Error.invalidData))
                }
            case let .failure(error): task.complete(with: .failure(error))
            }
        }
        return task
    }
}
