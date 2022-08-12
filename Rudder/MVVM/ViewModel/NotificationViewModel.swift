//
//  NotificationViewModel.swift
//  Rudder
//
//  Created by 박민호 on 2022/08/12.
//

import Foundation

class NotificationViewModel {
    var notifications: [UserNotification] = []
    
    let getNotificationFlag: Observable<Int?> = Observable(nil)
}

extension NotificationViewModel {
    func requestNotifications(endNotificationId: Int){
        RequestNotifications.uploadInfo(endNotificationId: endNotificationId, completion: { (notifications: [UserNotification]? ) in
            guard let notifications = notifications else {
                self.getNotificationFlag.value = -1
                return
            }
            self.notifications = notifications
            self.getNotificationFlag.value = 1
        })
    }
}

