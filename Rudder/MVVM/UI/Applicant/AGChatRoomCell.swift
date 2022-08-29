//
//  AGChatRoomCell.swift
//  Rudder
//
//  Created by 박민호 on 2022/08/22.
//
import UIKit

class AGChatRoomCell : UITableViewCell {
    
    @IBOutlet weak var insideView: UIView!
    
    @IBOutlet weak var chatRoomImageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var chatRoomTitleLabel: UILabel!
    @IBOutlet weak var recentChatLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}

extension AGChatRoomCell {
    func configure(isEmptyCell: Bool, partyTime: String!, chatRoom: ChatRoom!, tableView: UITableView, indexPath: IndexPath) {
        
        
        ColorDesign.setShadow(view: insideView)
        
        guard !isEmptyCell else {
            RequestImage.downloadImage(from: URL(string:"https://d17a6yjghl1rix.cloudfront.net/dark_party_mock.png")!, imageView: self.chatRoomImageView)
            self.dateLabel.text = " "
            self.chatRoomTitleLabel.text = "Waiting for the Host's Move"
            self.recentChatLabel.text = " "
            self.isUserInteractionEnabled = false
            return
        }
        
        RequestImage.downloadImage(from: URL(string:chatRoom.chatRoomImageUrl)!, imageView: self.chatRoomImageView)
        self.dateLabel.text = Utils.stringDate(date: partyTime)
        self.chatRoomTitleLabel.text = chatRoom.chatRoomTitle
        self.recentChatLabel.text = chatRoom.recentMessage
        
        
    }
}
