//
//  UIRefreshControl+Helpers.swift
//  EssentialFeediOS
//
//  Created by Jair Moreno Gaspar on 07/01/21.
//  Copyright © 2021 Jair Moreno G. All rights reserved.
//

import UIKit

extension UIRefreshControl {
    func update(isRefreshing: Bool) {
        isRefreshing ? beginRefreshing() : endRefreshing()
    }
}
