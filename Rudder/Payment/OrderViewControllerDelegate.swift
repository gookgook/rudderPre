//
//  OrderViewControllerDelegate.swift
//  Rudder
//
//  Created by 박민호 on 2022/07/19.
//

import Foundation

protocol OrderViewControllerDelegate: AnyObject {
    func didRequestPayWithApplyPay()
    func didRequestPayWithCard()
}
