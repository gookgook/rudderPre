//
//  HeaderView.swift
//  Rudder
//
//  Created by 박민호 on 2022/07/19.
//

import UIKit

class HeaderView : UIStackView {
    lazy var closeButton = makeCloseButton()
    private var title: String = ""

    init(title: String) {
        super.init(frame: .zero)
        commonInit()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit() {
        distribution = .fillProportionally
        alignment = .center
        layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        isLayoutMarginsRelativeArrangement = true
        addArrangedSubview(closeButton)
        addArrangedSubview(makeOrderTitleLabel(text: title))

        let hiddenCloseButton = makeCloseButton()
        hiddenCloseButton.alpha = 0.0
        addArrangedSubview(hiddenCloseButton)
    }
}

extension HeaderView {
    private func makeCloseButton() -> UIButton {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = Color.descriptionFont

        return button
    }


    private func makeOrderTitleLabel(text: String) -> UILabel {
        let label = UILabel()
        label.text = "Place your order"
        label.textColor = UIColor.black
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textAlignment = .center

        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }
}
