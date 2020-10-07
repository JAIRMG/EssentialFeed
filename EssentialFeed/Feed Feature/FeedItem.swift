//
//  FeedItem.swift
//  EssentialFeed
//
//  Created by Jair Moreno G on 30/09/20.
//  Copyright © 2020 Jair Moreno G. All rights reserved.
//

import Foundation

public struct FeedItem: Equatable {
    let id: UUID
    let description: String?
    let location: String?
    let imageURL: URL
}
