//
//  FeedLoader.swift
//  EssentialFeed
//
//  Created by Jair Moreno G on 30/09/20.
//  Copyright © 2020 Jair Moreno G. All rights reserved.
//

import Foundation

enum Result {
    case success([FeedItem])
    case error(Error)
}

protocol FeedLoader {
    func load(completion: @escaping (Result) -> Void)
}
