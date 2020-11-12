//
//  FeedStore.swift
//  EssentialFeed
//
//  Created by Jair Moreno Gaspar on 10/11/20.
//  Copyright © 2020 Jair Moreno G. All rights reserved.
//

import Foundation

public protocol FeedStore {
    typealias DeletionCompletion = (Error?) -> Void
    typealias InsertionCompletion = (Error?) -> Void
    
    func deleteCachedFeed(completion: @escaping DeletionCompletion)
    func insert(_ feed: [LocalFeedImage], timestamp: Date, completion: @escaping InsertionCompletion)
    func retrieve()
    
}
