//
//  MyChat.swift
//  Rudder
//
//  Created by 박민호 on 2022/06/20.
//

import UIKit

class MyChatCell : UITableViewCell {
    
    @IBOutlet weak var timeAgoLabel : UILabel!
    @IBOutlet weak var chatBodyView: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}

extension MyChatCell {
    func configure(chat: Chat, tableView: UITableView, indexPath: IndexPath) {
        //이부분 enum으로 바꾸자
        self.chatBodyView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        self.chatBodyView.text = chat.chatMessageBody
        self.timeAgoLabel.text = "3:15 pm"//Utils.timeAgo(postDate: job.timeAgo) 수정 요함 **********************************************
    }
}
