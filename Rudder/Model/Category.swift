//
//  Category.swift
//  Rudder
//
//  Created by Brian Bae on 05/09/2021.
//

import Foundation

struct Category: Codable {
    let categoryId: Int
    let categoryName: String
    let isSelected: Bool! //이거 selected에는 isselect 안오는거때매
    let isMember: String
    let categoryType: String
    let categoryAbbreviation: String
}
