//
//  RemoteFeedItem.swift
//  EssentialFeed
//
//  Created by Jair Moreno Gaspar on 11/11/20.
//  Copyright © 2020 Jair Moreno G. All rights reserved.
//

import Foundation

struct RemoteFeedItem: Decodable {
    let id: UUID
    let description: String?
    let location: String?
    let image: URL
}
