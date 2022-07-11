//
//  Seperator.swift
//  Rudder
//
//  Created by 박민호 on 2022/03/23.
//

import UIKit

class Separator: UIView {
    let line = UIView()

       override init(frame: CGRect) {
           super.init(frame: frame)
           configure()
       }


       required init?(coder: NSCoder) {
           fatalError("init(coder:) has not been implemented")
       }

       private func configure() {
           backgroundColor = .white

           addSubview(line)
           line.translatesAutoresizingMaskIntoConstraints = false
           line.backgroundColor = .secondaryLabel

           NSLayoutConstraint.activate([
               line.centerYAnchor.constraint(equalTo: self.centerYAnchor),
               line.centerXAnchor.constraint(equalTo: self.centerXAnchor),
               line.heightAnchor.constraint(equalToConstant: 0.9),
               line.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.9 )
           ])
       }
}
