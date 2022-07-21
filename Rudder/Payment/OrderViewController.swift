//
//  OrderViewController.swift
//  Rudder
//
//  Created by 박민호 on 2022/07/19.
//

import UIKit

class OrderViewController : UIViewController {
    weak var delegate: OrderViewControllerDelegate?
    var applePayResponse : String?
    var str: String
    init(str: String) {
        
        self.str = str
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        let orderView = OrderView(frame: .zero, str: str)
        self.view = orderView

        orderView.addCardButton.addTarget(self, action: #selector(didTapPayButton), for: .touchUpInside)
        orderView.applePayButton.addTarget(self, action: #selector(didTapApplePayButton), for: .touchUpInside)
        orderView.closeButton.addTarget(self, action: #selector(didTapCloseButton), for: .touchUpInside)
    }

        // MARK: - Button tap functions
        
    @objc private func didTapCloseButton() {
        dismiss(animated: true, completion: nil)
    }
        
    @objc private func didTapPayButton() {
        delegate?.didRequestPayWithCard()
    }
        
    @objc private func didTapApplePayButton() {
        delegate?.didRequestPayWithApplyPay()
            
    }
    
}

extension OrderViewController: HalfSheetPresentationControllerHeightProtocol {
    var halfsheetHeight: CGFloat {
        return (view as! OrderView).stackView.systemLayoutSizeFitting(UIView.layoutFittingExpandedSize).height
    }
}
