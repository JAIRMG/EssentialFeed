//
//  FeedItemsMapper.swift
//  EssentialFeed
//
//  Created by Jair Moreno G on 07/10/20.
//  Copyright © 2020 Jair Moreno G. All rights reserved.
//

import Foundation

final class FeedItemsMapper {
    
    private struct RootNode: Decodable {
        let items: [Item]
        
        var feed: [FeedItem] {
            return items.map { $0.item }
        }
    }

    private struct Item: Decodable {
        let id: UUID
        let description: String?
        let location: String?
        let image: URL
        
        var item: FeedItem {
            return FeedItem(id: id,
                            description: description,
                            location: location,
                            imageURL: image)
        }
    }
    
    private static let statusCode200 = 200
        
    static func map(_ data: Data, _ response: HTTPURLResponse) -> RemoteFeedLoader.Result {
        
        guard response.statusCode == statusCode200, let root = try? JSONDecoder().decode(RootNode.self, from: data) else {
            return .failure(.invalidData)
        }
        return .success(root.feed)
    }

}
