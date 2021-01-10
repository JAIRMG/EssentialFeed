//
//  FeedErrorViewModel.swift
//  EssentialFeed
//
//  Created by Jair Moreno Gaspar on 09/01/21.
//  Copyright © 2021 Jair Moreno G. All rights reserved.
//

import Foundation

public struct FeedErrorViewModel {
    public let message: String?
    
    static var noError: FeedErrorViewModel {
        return FeedErrorViewModel(message: nil)
    }
    
    static func error(message: String) -> FeedErrorViewModel {
        return FeedErrorViewModel(message: message)
    }
}
