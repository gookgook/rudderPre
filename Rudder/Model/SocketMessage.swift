//
//  SocketMessage.swift
//  Rudder
//
//  Created by 박민호 on 2022/07/21.
//

import Foundation

/*struct SocketMessage: Decodable {
    let messageType: String
    let payload: Chat
}*/

struct SocketMessage: Decodable {  //특수한 경우라
    let socketMessage: PayloadContent
}

enum PayloadContent {
    case chat(Chat)
    case notification(UserNotification)
    case unsupported
}

extension PayloadContent:Decodable {
    private enum CodingKeys: String, CodingKey {
        case messageType
        case payload
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let type = try container.decode(String.self, forKey: .messageType)
            
        switch type {
        case "CHAT_MESSAGE":
            let payload = try? container.decode(Chat.self, forKey: .payload)
            self = payload.map { .chat($0) } ?? .unsupported
        case "NOTIFICATION":
            let payload = try? container.decode(UserNotification.self, forKey: .payload)
            self = payload.map { .notification($0) } ?? .unsupported
        default:
            self = .unsupported
        }
    }
}
