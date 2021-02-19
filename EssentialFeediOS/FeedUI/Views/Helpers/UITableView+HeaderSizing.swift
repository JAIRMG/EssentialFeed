//
//  UITableView+HeaderSizing.swift
//  EssentialFeediOS
//
//  Created by Jair Moreno Gaspar on 18/02/21.
//  Copyright © 2021 Jair Moreno G. All rights reserved.
//

import UIKit

extension UITableView {
    func sizeTableHeaderToFit() {
        guard let header = tableHeaderView else { return }
        
        let size = header.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        let needsFrameUpdate = header.frame.height != size.height
        
        if needsFrameUpdate {
            header.frame.size.height = size.height
            tableHeaderView = header
        }
    }
}
