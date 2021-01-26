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
    typealias InsertionResult = Swift.Result<Void, Error>

    func insert(_ data: Data, for url: URL, completion: @escaping (InsertionResult) -> Void)
    func retrieve(dataForURL url: URL, completion: @escaping (Result) -> Void)
}
