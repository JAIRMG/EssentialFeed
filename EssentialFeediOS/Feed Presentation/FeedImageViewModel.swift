//
//  FeedImageViewModel.swift
//  EssentialFeediOS
//
//  Created by Jair Moreno Gaspar on 01/01/21.
//  Copyright © 2021 Jair Moreno G. All rights reserved.
//

struct FeedImageViewModel<Image> {
    let description: String?
    let location: String?
    let image: Image?
    let isLoading: Bool
    let shouldRetry: Bool
    
    var hasLocation: Bool {
        return location != nil
    }
}
