//
//  FeedCache.swift
//  EssentialFeed
//
//  Created by Jair Moreno Gaspar on 10/02/21.
//  Copyright © 2021 Jair Moreno G. All rights reserved.
//

import Foundation

public protocol FeedCache {
    typealias SaveResult = Result<Void, Error>
    
    func save(_ feed: [FeedImage], completion: @escaping (SaveResult) -> Void)
}
