//
//  SocketMessage.swift
//  Rudder
//
//  Created by 박민호 on 2022/07/21.
//

import Foundation

struct SocketMessage: Codable {
    let messageType: String
    let payload: Chat
}
