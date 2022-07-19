//
//  HairlineView.swift
//  Rudder
//
//  Created by 박민호 on 2022/07/19.
//

import UIKit

class HairlineView : UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit() {
        backgroundColor = Color.hairlineColor
    }

    override var intrinsicContentSize: CGSize {
        return CGSize(width: UIView.noIntrinsicMetric, height: 1)
    }
}
