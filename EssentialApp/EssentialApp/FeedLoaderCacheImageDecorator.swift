//
//  FeedLoaderCacheImageDecorator.swift
//  EssentialApp
//
//  Created by Jair Moreno Gaspar on 11/02/21.
//

import Foundation
import EssentialFeed

public class FeedLoaderCacheImageDecorator: FeedImageDataLoader {

    private let loader: FeedImageDataLoader
    private let cache: FeedImageCache
    
    public init(decoratee: FeedImageDataLoader, cache: FeedImageCache) {
        self.loader = decoratee
        self.cache = cache
    }
    
    public func loadImageData(from url: URL, completion: @escaping (FeedImageDataLoader.Result) -> Void) -> FeedImageDataLoaderTask {
        let task = loader.loadImageData(from: url, completion: { [weak self] result in
            completion(result.map { data in
                self?.cache.saveIgnoringError(data, url: url)
                return data
            })
        })
        return task
    }
}

private extension FeedImageCache {
    func saveIgnoringError(_ data: Data, url: URL) {
        save(data, for: url) { _ in }
    }
}
