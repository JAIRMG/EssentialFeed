//
//  UITableView+Dequeueing.swift
//  EssentialFeediOS
//
//  Created by Jair Moreno Gaspar on 03/01/21.
//  Copyright © 2021 Jair Moreno G. All rights reserved.
//

import UIKit

extension UITableView {
    func dequeueReusableCell<T: UITableViewCell>() -> T {
        let identifier = String(describing: T.self)
        return dequeueReusableCell(withIdentifier: identifier) as! T
    }
}
