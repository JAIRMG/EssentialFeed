//
//  FeedImageDataStore.swift
//  EssentialFeed
//
//  Created by Jair Moreno Gaspar on 25/01/21.
//  Copyright © 2021 Jair Moreno G. All rights reserved.
//

import Foundation

public protocol FeedImageDataStore {
    typealias Result = Swift.Result<Data?, Error>

    func retrieve(dataForURL url: URL, completion: @escaping (Result) -> Void)
}
