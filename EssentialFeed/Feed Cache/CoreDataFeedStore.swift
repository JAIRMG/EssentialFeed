//
//  CoreDataFeedStore.swift
//  EssentialFeed
//
//  Created by Jair Moreno Gaspar on 30/11/20.
//  Copyright © 2020 Jair Moreno G. All rights reserved.
//

import Foundation

public class CoreDataFeedStore: FeedStore {
    
    public init() { }
    
    public func deleteCachedFeed(completion: @escaping DeletionCompletion) {
        
    }
    
    public func insert(_ feed: [LocalFeedImage], timestamp: Date, completion: @escaping InsertionCompletion) {
        
    }
    
    public func retrieve(completion: @escaping RetrievalCompletion) {
        completion(.empty)
    }
    
    
}
