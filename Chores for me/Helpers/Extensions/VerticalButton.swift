//
//  VerticalButton.swift
//  Chores for me
//
//  Created by Bright Roots 2019 on 20/04/21.
//

import UIKit
import Designable

class VerticalButton: DesignableButton {

    override open func layoutSubviews() {
        super.layoutSubviews()
        let padding : CGFloat = 2.0
        if let imageView = self.imageView {
            imageView.frame.origin.x = (self.bounds.size.width - imageView.frame.size.width) / 2.0
            imageView.frame.origin.y = max(0,(self.bounds.size.height - (imageView.frame.size.height + (titleLabel?.frame.size.height ?? 0.0) + padding)) / 2.0)
        }
        if let titleLabel = self.titleLabel {
            titleLabel.frame.origin.x = 0
            titleLabel.frame.origin.y = self.bounds.size.height - titleLabel.frame.size.height
            titleLabel.frame.size.width = self.bounds.size.width
            titleLabel.textAlignment = .center
        }
    }

}
