//
//  Chat.swift
//  Rudder
//
//  Created by 박민호 on 2022/06/20.
//

import Foundation

struct Chat: Codable {
    let chatMessageId: Int
    let chatMessageBody: String
    let chatMessageTime: String
    let sendUserInfoId: Int
    let sendUserNickname: String
    let isMine: Bool
    let chatRoomId: Int
}


