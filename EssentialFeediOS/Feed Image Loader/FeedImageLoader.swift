//
//  FeedImageLoader.swift
//  EssentialFeediOS
//
//  Created by Jair Moreno Gaspar on 31/12/20.
//  Copyright © 2020 Jair Moreno G. All rights reserved.
//

import Foundation

public protocol FeedImageDataLoaderTask {
    func cancel()
}

public protocol FeedImageDataLoader {
    typealias Result = Swift.Result<Data,Error>
    func loadImageData(from url: URL, completion: @escaping (Result) -> Void) -> FeedImageDataLoaderTask
}
