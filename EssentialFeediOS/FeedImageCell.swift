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
    
    public let locationContainer = UIView()
    public let locationLabel = UILabel()
    public let descriptionLabel = UILabel()
    public let feedImageContainer = UIView()
    public let feedImageView = UIImageView()
    
    private(set) public lazy var feedImageRetryButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(didTapRetry), for: .touchUpInside)
        return button
    }()
    
    @objc private func didTapRetry() {
        onRetry?()
    }
}
