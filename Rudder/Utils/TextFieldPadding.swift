//
//  TextFieldPadding.swift
//  Rudder
//
//  Created by 박민호 on 2022/07/29.
//

import UIKit

extension UITextField {
    func addLeftPadding(padding: Int) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: padding, height: Int(self.frame.height)))
        self.leftView = paddingView
        self.leftViewMode = ViewMode.always
    }
}
