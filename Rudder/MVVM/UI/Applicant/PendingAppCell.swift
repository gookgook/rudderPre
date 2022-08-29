//
//  PendingAppCell.swift
//  Rudder
//
//  Created by 박민호 on 2022/08/22.
//

import UIKit

class PendingAppCell: UITableViewCell {
    @IBOutlet weak var chatRoomImageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var partyTitleLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}

extension PendingAppCell {
    func configure(isEmptyCell: Bool ,party: Party!, tableView: UITableView, indexPath: IndexPath) {
        
        guard !isEmptyCell else {
            RequestImage.downloadImage(from: URL(string:"https://d17a6yjghl1rix.cloudfront.net/dark_profile_image.png")!, imageView: chatRoomImageView)
            self.partyTitleLabel.text = "Let's find the Pre for you!"
            statusLabel.text = nil
            self.isUserInteractionEnabled = false
            return
        }
        
        RequestImage.downloadImage(from: URL(string:party.partyThumbnailUrl)!, imageView: chatRoomImageView)
        //dateLabel.text = Utils.stringDate(date: party.partyTime)
        partyTitleLabel.text = party.partyTitle
        statusLabel.text = " " + party.partyStatus + "  "
        statusLabel.layer.cornerRadius = 5
        
        statusLabel.clipsToBounds  =  true
        //statusLabel.layer.
    }
}
