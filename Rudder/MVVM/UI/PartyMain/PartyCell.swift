//
//  PartyCell.swift
//  Rudder
//
//  Created by 박민호 on 2022/07/08.
//

import UIKit

class PartyCell : UITableViewCell {
    
    @IBOutlet weak var partyThumbnailView: UIImageView!
    @IBOutlet weak var universityNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var partyTitleView: UITextView!
    @IBOutlet weak var memberNumberLabel: UILabel!
    @IBOutlet weak var beerTypeLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}

extension PartyCell {
    func configure(party: Party, tableView: UITableView, indexPath: IndexPath) {
        RequestImage.downloadImage(from: URL(string: party.partyThumbnailUrl)!, imageView: partyThumbnailView)
        universityNameLabel.text = party.universityName
        dateLabel.text = Utils.stringDate(date: party.partyTime) 
        partyTitleView.text = party.partyTitle
        memberNumberLabel.text = String(party.currentNumberOfMember) + " / "+String(party.totalNumberOfMember)
        beerTypeLabel.text = "Rudder Beer"
    }
}
