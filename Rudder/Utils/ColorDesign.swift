//
//  ColorDesign.swift
//  Rudder
//
//  Created by 박민호 on 2022/07/26.
//

import UIKit

class ColorDesign {
    static func setShadow(view: UIView){
        view.layer.borderWidth = 0.5
        view.layer.borderColor = UIColor.clear.cgColor
        view.layer.shadowColor = UIColor.systemGray5.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 0)
        view.layer.shadowOpacity = 0.8
        view.layer.shadowRadius = 8
    }
    
}
