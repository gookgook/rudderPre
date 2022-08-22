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
    func configure(party: Party, tableView: UITableView, indexPath: IndexPath) {
        RequestImage.downloadImage(from: URL(string:party.partyThumbnailUrl)!, imageView: chatRoomImageView)
        //dateLabel.text = Utils.stringDate(date: party.partyTime)
        partyTitleLabel.text = party.partyTitle
        statusLabel.text = " " + party.partyStatus + "  "
        statusLabel.layer.cornerRadius = 5
        
        statusLabel.clipsToBounds  =  true
        //statusLabel.layer.
    }
}
