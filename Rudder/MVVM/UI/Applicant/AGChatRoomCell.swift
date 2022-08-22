//
//  AGChatRoomCell.swift
//  Rudder
//
//  Created by 박민호 on 2022/08/22.
//
import UIKit

class AGChatRoomCell : UITableViewCell {
    
    @IBOutlet weak var chatRoomImageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var chatRoomTitleLabel: UILabel!
    @IBOutlet weak var recentChatLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}

extension AGChatRoomCell {
    func configure(partyTime: String, chatRoom: ChatRoom, tableView: UITableView, indexPath: IndexPath) {
        
        RequestImage.downloadImage(from: URL(string:chatRoom.chatRoomImageUrl)!, imageView: self.chatRoomImageView)
        self.dateLabel.text = Utils.stringDate(date: partyTime)
        self.chatRoomTitleLabel.text = chatRoom.chatRoomTitle
        self.recentChatLabel.text = chatRoom.recentMessage
        
    }
}
