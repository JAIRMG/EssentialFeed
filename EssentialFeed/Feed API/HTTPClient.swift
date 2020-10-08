//
//  HTTPClient.swift
//  EssentialFeed
//
//  Created by Jair Moreno G on 07/10/20.
//  Copyright © 2020 Jair Moreno G. All rights reserved.
//

import Foundation

public enum HTTPClientResult {
    case success(Data, HTTPURLResponse)
    case failure(Error)
}

public protocol HTTPClient {
    func get(from url: URL, completion: @escaping (HTTPClientResult) -> Void)
}
