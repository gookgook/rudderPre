//
//  NotificationViewModel.swift
//  Rudder
//
//  Created by 박민호 on 2022/08/12.
//

import Foundation

final class NotificationViewModel {
    var notifications: [UserNotification] = []
    
    let getNotificationFlag: Observable<Int?> = Observable(nil)
    
    let isLoadingFlag: Observable<Bool> = Observable(false)
    let tabBarDestinationFlag: Observable<Int?> = Observable(nil)
}

extension NotificationViewModel {
    func requestNotifications(endNotificationId: Int){
        isLoadingFlag.value = true
        RequestNotifications.uploadInfo(endNotificationId: endNotificationId, completion: { (notifications: [UserNotification]? ) in
            guard let notifications = notifications else {
                self.getNotificationFlag.value = -1
                return
            }
            
            print("noti count  ",String(notifications.count))
            self.notifications = notifications
            self.getNotificationFlag.value = 1
            self.isLoadingFlag.value = false
        })
    }
    
    func touchUpNotifications(index: Int){
        switch notifications[index].notificationType {
        case "PARTY_APPLY" :
            tabBarDestinationFlag.value = 1
        case "PARTY_ACCEPTED" :
            tabBarDestinationFlag.value = 2
        default :
            tabBarDestinationFlag.value = 0
        }
    }
}

