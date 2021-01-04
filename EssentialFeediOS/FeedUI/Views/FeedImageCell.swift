//
//  FeedImageCell.swift
//  EssentialFeediOS
//
//  Created by Jair Moreno Gaspar on 30/12/20.
//  Copyright © 2020 Jair Moreno G. All rights reserved.
//

import UIKit

public final class FeedImageCell: UITableViewCell {
    
    var onRetry: (() -> Void)?
    
    @IBOutlet private(set) public var locationContainer: UIView!
    @IBOutlet private(set) public var locationLabel: UILabel!
    @IBOutlet private(set) public var feedImageContainer: UIView!
    @IBOutlet private(set) public var feedImageView: UIImageView!
    @IBOutlet private(set) public var feedImageRetryButton: UIButton!
    @IBOutlet private(set) public var descriptionLabel: UILabel!
    
    @IBAction private func didTapRetry() {
        onRetry?()
    }
}
