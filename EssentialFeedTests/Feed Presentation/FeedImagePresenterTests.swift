//
//  FeedImagePresenterTests.swift
//  EssentialFeedTests
//
//  Created by Jair Moreno Gaspar on 09/01/21.
//  Copyright © 2021 Jair Moreno G. All rights reserved.
//

import XCTest

final class FeedImagePresenter {
    init(view: Any) { }
}

class FeedImagePresenterTests: XCTestCase {
    func test_init_doesNotSendMessageToView() {
        let (_, view) = makeSUT()
        XCTAssertTrue(view.messages.isEmpty)
    }
    
    // MARK: - Helpers
    
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: FeedImagePresenter, view: ViewSpy) {
        let view = ViewSpy()
        let sut = FeedImagePresenter(view: view)
        trackForMemoryLeaks(instance: sut, file: file, line: line)
        trackForMemoryLeaks(instance: view, file: file, line: line)
        return (sut, view)
    }
    
    private class ViewSpy {
        var messages = [Any]()
    }
}
