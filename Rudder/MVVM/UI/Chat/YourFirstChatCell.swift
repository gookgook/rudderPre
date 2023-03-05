//
//  YourFirstChatCell.swift
//  Rudder
//
//  Created by 박민호 on 2022/08/23.
//

import UIKit

class YourFirstChatCell : UITableViewCell {
    
    @IBOutlet weak var timeAgoLabel : UILabel!
    @IBOutlet weak var chatBodyView: UITextView!
    
    @IBOutlet weak var nicknameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}

extension YourFirstChatCell {
    func configure(chat: Chat, tableView: UITableView, indexPath: IndexPath) {
        
        self.chatBodyView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        self.chatBodyView.text = chat.chatMessageBody
        self.timeAgoLabel.text = Utils.chatDate(date: chat.chatMessageTime)
        self.nicknameLabel.text = chat.sendUserNickname
    }
}
