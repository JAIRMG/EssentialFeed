//
//  UIRefreshControl+TestHelpers.swift
//  EssentialFeediOSTests
//
//  Created by Jair Moreno Gaspar on 31/12/20.
//  Copyright © 2020 Jair Moreno G. All rights reserved.
//

import UIKit

extension UIRefreshControl {
    func simulatePullToRefresh() {
        simulate(event: .valueChanged)
    }
}
