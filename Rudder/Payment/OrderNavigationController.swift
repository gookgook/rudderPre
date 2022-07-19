//
//  OrderNavigationController.swift
//  Rudder
//
//  Created by 박민호 on 2022/07/19.
//

import UIKit

class OrderNavigationController : UINavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()

        setNavigationBarHidden(true, animated: false)
    }
}

extension OrderNavigationController: HalfSheetPresentationControllerHeightProtocol {
    var halfsheetHeight: CGFloat {
        return ((viewControllers.last as? HalfSheetPresentationControllerHeightProtocol)?.halfsheetHeight ?? 0.0) + navigationBar.bounds.height
    }
}
