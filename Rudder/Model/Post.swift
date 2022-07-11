//
//  Post.swift
//  Rudder
//
//  Created by Brian Bae on 14/07/2021.
//

import Foundation

struct Post: Codable, Equatable {
    
    // MARK: - Nested Types
    //let category: String
    let postId: Int
    let userNickname: String
    let userInfoId: Int
    
    let timeAgo: String
    var postBody: String //post 수정때매 var로 바꿈
    
    var likeCount: Int
    var commentCount: Int
    
    let categoryId: Int
    let categoryName: String
    let categoryAbbreviation: String
    
    var isLiked: Bool
    let isMine: Bool
    
    let imageUrls: [String]
    let userProfileImageUrl: String
    
}

extension Post {
    enum CodingKeys: String, CodingKey {
        case postId
        case userNickname
        case userInfoId
        case timeAgo = "postTime"
        case postBody
        case likeCount
        case commentCount
        case categoryId
        case categoryName
        case categoryAbbreviation
        case isLiked, isMine, imageUrls, userProfileImageUrl
    }
}
