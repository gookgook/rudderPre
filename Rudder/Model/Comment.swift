//
//  Comment.swift
//  Rudder
//
//  Created by Brian Bae on 28/07/2021.
//

import Foundation

struct Comment: Codable, Equatable {
    
    // MARK: - Nested Types
    //let category: String
    let commentId: Int
    
    let userNickname: String
    let timeAgo: String
    let commentBody: String
    let userInfoId: Int
    let status: String
    let groupNum: Int
    let likeCount: Int
    let isMine: Bool
    
    var isLiked: Bool
    
    let userProfileImageUrl: String
    // MARK: - Properties
    
    // MARK: Privates
}

extension Comment {
    enum CodingKeys: String, CodingKey {
        case commentId
        case userNickname
        case timeAgo = "postTime"
        case commentBody
        case userInfoId
        case status
        case groupNum
        case likeCount
        case isLiked, isMine, userProfileImageUrl
    }
}
