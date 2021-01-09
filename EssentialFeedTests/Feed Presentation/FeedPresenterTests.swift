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
        let view = ViewSpy()
        _ = FeedPresenter(view: view)
        
        XCTAssertTrue(view.messages.isEmpty, "Expected no view messages")
    }
    
    //MARK: - Helpers
    
    class ViewSpy {
        let messages = [Any]()
    }
    
}
