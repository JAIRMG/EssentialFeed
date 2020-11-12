//
//  LocalFeedLoader.swift
//  EssentialFeed
//
//  Created by Jair Moreno Gaspar on 10/11/20.
//  Copyright © 2020 Jair Moreno G. All rights reserved.
//

import Foundation

public final class LocalFeedLoader {
    let store: FeedStore
    let currentDate : () -> Date
    
    public typealias SaveResult = Error?
    public typealias LoadResult = LoadFeedResult
    
    public init(store: FeedStore, currentDate: @escaping () -> Date) {
        self.store = store
        self.currentDate = currentDate
    }
    
    public func save(_ feed: [FeedImage], completion: @escaping (SaveResult) -> Void) {
        store.deleteCachedFeed { [weak self] error in
            guard let self = self else { return }
            if let cacheDeletionError = error {
                completion(cacheDeletionError)
            } else {
                self.cache(feed, with: completion)
            }
        }
    }
    
    private func cache(_ feed: [FeedImage], with completion: @escaping (SaveResult) -> Void) {
        store.insert(feed.toLocal(), timestamp: currentDate()) { [weak self] error in
            guard self != nil else { return }
            completion(error)
        }
    }
    
    public func load(completion: @escaping (LoadResult) -> Void) {
        store.retrieve { result in
            
            switch result {
            case .empty:
                completion(.success([]))
            case .failure(let error):
                completion(.failure(error))
            case let .found(images, _):
                completion(.success(images.toModels()))
            }
        }
    }
}

private extension Array where Element == FeedImage {
    func toLocal() -> [LocalFeedImage] {
        map { LocalFeedImage(id: $0.id,
                            description: $0.description,
                            location: $0.location,
                            url: $0.url) }
    }
}

private extension Array where Element == LocalFeedImage {
    func toModels() -> [FeedImage] {
        map { FeedImage(id: $0.id,
                            description: $0.description,
                            location: $0.location,
                            url: $0.url) }
    }
}