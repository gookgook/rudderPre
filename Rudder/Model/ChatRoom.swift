//
//  ChatRoom.swift
//  Rudder
//
//  Created by 박민호 on 2022/07/01.
//

import Foundation

struct ChatRoom: Codable {
    let chatRoomTitle: String
    let chatRoomId: Int
    let notReadMessageCount: Int
    let recentMessage: String!
    let recentMessageTime: String!
    //let chatRoomName: String
}
