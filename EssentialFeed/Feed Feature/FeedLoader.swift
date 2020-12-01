//
//  FeedLoader.swift
//  EssentialFeed
//
//  Created by Jair Moreno G on 30/09/20.
//  Copyright © 2020 Jair Moreno G. All rights reserved.
//

import Foundation

public enum LoadFeedResult {
    case success([FeedImage])
    case failure(Error)
}

public protocol FeedLoader {
    func load(completion: @escaping (LoadFeedResult) -> Void)
}
