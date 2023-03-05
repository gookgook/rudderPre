//
//  YourChat.swift
//  Rudder
//
//  Created by 박민호 on 2022/06/20.
//

import UIKit

class YourChatCell : UITableViewCell {
    
    @IBOutlet weak var timeAgoLabel : UILabel!
    @IBOutlet weak var chatBodyView: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}

extension YourChatCell {
    func configure(chat: Chat, tableView: UITableView, indexPath: IndexPath) {
        
        self.chatBodyView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        self.chatBodyView.text = chat.chatMessageBody
        self.timeAgoLabel.text = Utils.chatDate(date: chat.chatMessageTime)
    }
}
