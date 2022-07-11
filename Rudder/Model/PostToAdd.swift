//
//  PostToAdd.swift
//  Rudder
//
//  Created by Brian Bae on 25/08/2021.
//

import Foundation

struct PostToAdd: Codable {
    let categoryId: Int
    let isImageExist: Bool
    let postBody: String
}
