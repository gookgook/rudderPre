//
//  NotificationCell.swift
//  Rudder
//
//  Created by 박민호 on 2022/08/12.
//

import UIKit

class NotificationCell : UITableViewCell {
    
    @IBOutlet weak var notificationTitleView: UITextView!
    @IBOutlet weak var notificationBodyLabel: UILabel!
    
    @IBOutlet weak var timeAgoLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}

extension NotificationCell {
    func configure(notification: UserNotification, tableView: UITableView, indexPath: IndexPath) {
        self.notificationTitleView.text = notification.notificationTitle
        self.notificationBodyLabel.text = notification.notificationBody
        self.timeAgoLabel.text = Utils.timeAgo(postDate: notification.notificationTime)
    }
}

