//
//  FeedImageCache.swift
//  EssentialFeed
//
//  Created by Jair Moreno Gaspar on 11/02/21.
//  Copyright © 2021 Jair Moreno G. All rights reserved.
//

import Foundation

public protocol FeedImageCache {
    typealias SaveResult = Result<Void, Swift.Error>
    
    func save(_ data: Data, for url: URL, completion: @escaping (SaveResult) -> Void)
}
