//
//  FeedItemsMapper.swift
//  EssentialFeed
//
//  Created by Jair Moreno G on 07/10/20.
//  Copyright © 2020 Jair Moreno G. All rights reserved.
//

import Foundation

final class FeedItemsMapper {
    
    private struct Root: Decodable {
        let items: [RemoteFeedItem]
    }
    
    static func map(_ data: Data, _ response: HTTPURLResponse) throws -> [RemoteFeedItem] {
        
        guard response.isOK, let root = try? JSONDecoder().decode(Root.self, from: data) else {
            throw RemoteFeedLoader.Error.invalidData
        }
        return root.items
    }

}
