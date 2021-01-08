//
//  ErrorView.swift
//  EssentialFeediOS
//
//  Created by Jair Moreno Gaspar on 07/01/21.
//  Copyright © 2021 Jair Moreno G. All rights reserved.
//

import UIKit

public final class ErrorView: UIView {
    @IBOutlet private var label: UILabel!

    public var message: String? {
        get { return label.text }
        set { label.text = newValue }
    }

    public override func awakeFromNib() {
        super.awakeFromNib()

        label.text = nil
    }
}
