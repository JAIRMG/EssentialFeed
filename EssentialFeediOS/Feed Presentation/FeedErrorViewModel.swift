//
//  FeedErrorViewModel.swift
//  EssentialFeediOS
//
//  Created by Jair Moreno Gaspar on 07/01/21.
//  Copyright © 2021 Jair Moreno G. All rights reserved.
//

struct FeedErrorViewModel {
    let message: String?
    
    static var noError: FeedErrorViewModel {
        return FeedErrorViewModel(message: nil)
    }

    static func error(message: String) -> FeedErrorViewModel {
        return FeedErrorViewModel(message: message)
    }
}
