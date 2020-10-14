//
//  XCTestCase+MemoryLeakTracking.swift
//  EssentialFeedTests
//
//  Created by Jair Moreno G on 13/10/20.
//  Copyright © 2020 Jair Moreno G. All rights reserved.
//

import XCTest

extension XCTestCase {
    func trackForMemoryLeaks(instance: AnyObject, file: StaticString = #file, line: UInt = #line) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, "Instance should have been deallocated, potential memory leak", file: file, line: line)
        }
    }
}
