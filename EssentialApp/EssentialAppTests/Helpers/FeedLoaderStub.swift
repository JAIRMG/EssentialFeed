//
//  FeedLoaderStub.swift
//  EssentialAppTests
//
//  Created by Jair Moreno Gaspar on 09/02/21.
//

import Foundation
import EssentialFeed

class FeedLoaderStub: FeedLoader {
    
    private let result: FeedLoader.Result
    
    init(result: FeedLoader.Result) {
        self.result = result
    }
    
    func load(completion: @escaping (FeedLoader.Result) -> Void) {
        completion(result)
    }

}
