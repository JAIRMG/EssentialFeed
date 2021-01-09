//
//  FeedPresenterTests.swift
//  EssentialFeedTests
//
//  Created by Jair Moreno Gaspar on 08/01/21.
//  Copyright © 2021 Jair Moreno G. All rights reserved.
//

import XCTest

class FeedPresenter {
    
    init(view: Any) {}
}

class FeedPresenterTests: XCTestCase {
    
    func test_init_doestNotSendMessagesToView() {
        let (_, view) = makeSUT()
        
        XCTAssertTrue(view.messages.isEmpty, "Expected no view messages")
    }
    
    //MARK: - Helpers
    
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: FeedPresenter, view: ViewSpy) {
        let view = ViewSpy()
        let sut = FeedPresenter(view: view)
        trackForMemoryLeaks(instance: view, file: file, line: line)
        trackForMemoryLeaks(instance: sut, file: file, line: line)
        return (sut, view)
    }
    
    class ViewSpy {
        let messages = [Any]()
    }
    
}
