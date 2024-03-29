//
//  OrderView.swift
//  Rudder
//
//  Created by 박민호 on 2022/07/19.
//

import UIKit

class OrderView : UIView {

    lazy var stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 30
        view.isLayoutMarginsRelativeArrangement = true
        view.layoutMargins = UIEdgeInsets(top: 30, left: 30, bottom: 30, right: 30)

        return view
    }()
    
    var str: String!

    lazy var addCardButton = ActionButton(backgroundColor: Color.primaryAction, title: "Pay with card", image: nil)
    lazy var applePayButton = ActionButton(backgroundColor: Color.applePayBackground, title: nil, image:UIImage(systemName: "applelogo"))
    private lazy var headerView = HeaderView(title: "Place your order")

    var closeButton: UIButton {
        return headerView.closeButton
    }
    
    
    
    override convenience init(frame: CGRect) {
        self.init(frame: frame, str: "mock")
    }
    
    init(frame: CGRect, str: String) {
        self.str = str
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //commonInit()
    }
    
    private func commonInit() {
        backgroundColor = Color.popupBackground

        stackView.addArrangedSubview(headerView)
        stackView.addArrangedSubview(TableRowView(heading: str, title: "Lauren Nobel", subtitle: "1455 Market Street\nSan Francisco, CA, 94103"))
        stackView.addArrangedSubview(HairlineView())
        stackView.addArrangedSubview(TableRowView(heading: "Total", title: "$1.00", subtitle: nil))
        stackView.addArrangedSubview(HairlineView())
        stackView.addArrangedSubview(makeRefundLabel())

        let payStackView = UIStackView()
        payStackView.spacing = 12
        payStackView.distribution = .fillEqually
        payStackView.addArrangedSubview(addCardButton)
        payStackView.addArrangedSubview(applePayButton)
        stackView.addArrangedSubview(payStackView)

        addSubview(stackView)

        stackView.pinToTop(ofView: self)
    }
}

extension OrderView {
    private func makeRefundLabel() -> UILabel {
        let label = UILabel()

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 8
        let attributes = [NSAttributedString.Key.paragraphStyle : paragraphStyle]

        label.attributedText = NSMutableAttributedString(string: "You can refund this transaction through your Square dashboard, goto squareup.com/dashboard.", attributes: attributes)
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = UIColor(red: 0.48, green: 0.48, blue: 0.48, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }
}

