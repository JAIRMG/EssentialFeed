//
//  SharedTestHelpers.swift
//  EssentialFeedTests
//
//  Created by Jair Moreno Gaspar on 16/11/20.
//  Copyright © 2020 Jair Moreno G. All rights reserved.
//

import Foundation

func anyNSError() -> NSError {
    NSError(domain: "any error", code: 0)
}
 
func AnyURL() -> URL {
    URL(string: "http://a-url.com")!
}

func anyData() -> Data {
    Data("any data".utf8)
}
