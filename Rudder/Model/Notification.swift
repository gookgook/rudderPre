//
//  Notification.swift
//  Rudder
//
//  Created by 박민호 on 2022/02/21.
//

import Foundation

struct UserNotification: Codable {
    let notificationId: Int
    let notificationType: String
    let notificationTime: String
    let itemId: Int
    let notificationBody: String
    let notificationTitle: String
    
}
