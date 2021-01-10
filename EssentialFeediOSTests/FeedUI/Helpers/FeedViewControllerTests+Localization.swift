//
//  FeedViewControllerTests+Localization.swift
//  EssentialFeediOSTests
//
//  Created by Jair Moreno Gaspar on 04/01/21.
//  Copyright © 2021 Jair Moreno G. All rights reserved.
//

import Foundation
import EssentialFeed
import XCTest

extension FeedUIIntegrationTests {
    func localized(_ key: String, file: StaticString = #file, line: UInt = #line) -> String {
        let tableName = "Feed"
        let bundle = Bundle(for: FeedPresenter.self)
        let value = bundle.localizedString(forKey: key, value: nil, table: tableName)
        
        if value == key {
            XCTFail("Missing localized string for key: \(key) in table: \(tableName)", file: file, line: line)
        }
        return value
    }
}
