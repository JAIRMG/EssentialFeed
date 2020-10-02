//
//  RemoteFeedLoader.swift
//  EssentialFeed
//
//  Created by Jair Moreno G on 01/10/20.
//  Copyright © 2020 Jair Moreno G. All rights reserved.
//

import Foundation

public protocol HTTPClient {
    func get(from: URL)
}

public final class RemoteFeedLoader {
    
    private let url: URL
    private let client: HTTPClient
    
    public init(url: URL, client: HTTPClient) {
        self.client = client
        self.url = url
    }
    
    public func load() {
        client.get(from: url)
    }
}
