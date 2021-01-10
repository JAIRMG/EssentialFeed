//
//  FeedImageViewModel.swift
//  EssentialFeediOS
//
//  Created by Jair Moreno Gaspar on 01/01/21.
//  Copyright © 2021 Jair Moreno G. All rights reserved.
//

public struct FeedImageViewModel<Image> {
    public let description: String?
    public let location: String?
    public let image: Image?
    public let isLoading: Bool
    public let shouldRetry: Bool
    
    public var hasLocation: Bool {
        return location != nil
    }
}
