//
//  Alcohol.swift
//  Rudder
//
//  Created by 박민호 on 2022/07/12.
//

import Foundation

struct Alcohol:Codable {
    
    let alcoholCount: Int
    let alcoholId: Int
    let alcoholImageUrl: String
    let alcoholName: String
    let alcoholUnit: String
    let currency: String
    let originalPrice: Float
    let price: Float
}
