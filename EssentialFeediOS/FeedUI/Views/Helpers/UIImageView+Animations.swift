//
//  UIImageView+Animations.swift
//  EssentialFeediOS
//
//  Created by Jair Moreno Gaspar on 03/01/21.
//  Copyright © 2021 Jair Moreno G. All rights reserved.
//

import UIKit

extension UIImageView {
    func setImageAnimated(_ newImage: UIImage?) {
        image = newImage
        
        guard newImage != nil else { return }
        alpha = 0
        UIView.animate(withDuration: 0.25) {
            self.alpha = 1
        }
    }
}
