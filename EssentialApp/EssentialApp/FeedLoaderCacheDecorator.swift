//
//  FeedLoaderCacheDecorator.swift
//  EssentialApp
//
//  Created by Jair Moreno Gaspar on 10/02/21.
//

import EssentialFeed

public class FeedLoaderCacheDecorator: FeedLoader {
    private let decoratee: FeedLoader
    private let cache: FeedCache
    
    public init(decoratee: FeedLoader, cache: FeedCache) {
        self.decoratee = decoratee
        self.cache = cache
    }
    
    public func load(completion: @escaping (FeedLoader.Result) -> Void) {
        decoratee.load { [weak self] result in
            completion(result.map { feed in
                self?.cache.saveIgnoringError(feed)
                return feed
            })
        }
    }
}

private extension FeedCache {
    func saveIgnoringError(_ feed: [FeedImage]) {
        save(feed) { _ in }
    }
}
