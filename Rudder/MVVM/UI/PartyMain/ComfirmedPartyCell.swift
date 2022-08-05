//
//  ComfirmedPartyCell.swift
//  Rudder
//
//  Created by 박민호 on 2022/08/05.
//

import UIKit

class ComfirmedPartyCell : UITableViewCell {
    
    @IBOutlet weak var partyThumbnailView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var partyTitleView: UITextView!
    @IBOutlet weak var chatBodyLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}

extension ComfirmedPartyCell {
    func configure(party: Party, tableView: UITableView, indexPath: IndexPath) {
        RequestImage.downloadImage(from: URL(string: party.partyThumbnailUrl)!, imageView: partyThumbnailView)
        dateLabel.text = Utils.stringDate(date: party.partyTime)
        partyTitleView.text = party.partyTitle
    }
}
