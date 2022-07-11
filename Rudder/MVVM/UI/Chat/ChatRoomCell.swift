//
//  ChatRoomCell.swift
//  Rudder
//
//  Created by 박민호 on 2022/07/06.
//

import UIKit

class ChatRoomCell : UITableViewCell {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nickNameLabel: UILabel!
    @IBOutlet weak var recentMessageLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}

extension ChatRoomCell {
    func configure(chatRoom: ChatRoom, tableView: UITableView, indexPath: IndexPath) {
        
        
        self.nickNameLabel.text = chatRoom.chatRoomTitle
        self.recentMessageLabel.text = chatRoom.recentMessage
    }
}
