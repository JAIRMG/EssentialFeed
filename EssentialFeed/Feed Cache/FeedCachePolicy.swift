//
//  FeedCachePolicy.swift
//  EssentialFeed
//
//  Created by Jair Moreno Gaspar on 17/11/20.
//  Copyright © 2020 Jair Moreno G. All rights reserved.
//

import Foundation

final class FeedCachePolicy {
    private init() {}
 
    private static let calendar = Calendar(identifier: .gregorian)
    
    private static var maxCacheAgeInDays: Int { 7 }
    
    static func validate(_ timestamp: Date, against date: Date) -> Bool {
        guard let maxCacheAge = calendar.date(byAdding: .day, value: maxCacheAgeInDays, to: timestamp) else {
            return false
        }
        return date < maxCacheAge
    }
}
