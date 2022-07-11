//
//  Notification.swift
//  Rudder
//
//  Created by 박민호 on 2022/02/21.
//

import Foundation

struct UserNotification: Codable {
    let itemBody : String
    let itemId : Int
    let itemTitle : String
    let notificationId: Int
    let notificationTime: String
    let notificationType: Int
}
