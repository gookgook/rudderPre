//
//  PartyCell.swift
//  Rudder
//
//  Created by 박민호 on 2022/07/08.
//

import UIKit

class PartyCell : UITableViewCell {
    
    @IBOutlet weak var partyThumbnailView: UIImageView!
    @IBOutlet weak var universityLogoImageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var partyTitleView: UITextView!
    @IBOutlet weak var memberNumberLabel: UILabel!
    //@IBOutlet weak var beerTypeLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        universityLogoImageView.layer.borderColor = UIColor.systemGray4.cgColor
        universityLogoImageView.layer.borderWidth = 0.5
    }
}

extension PartyCell {
    func configure(party: Party, tableView: UITableView, indexPath: IndexPath) {
        RequestImage.downloadImage(from: URL(string: party.partyThumbnailUrl)!, imageView: partyThumbnailView)
        RequestImage.downloadImage(from: URL(string: party.universityLogoUrl)!, imageView: universityLogoImageView)
        dateLabel.text = Utils.stringDate(date: party.partyTime) 
        partyTitleView.text = party.partyTitle
        memberNumberLabel.text = String(party.currentNumberOfMember) + " / "+String(party.totalNumberOfMember)
        //beerTypeLabel.text = "Rudder Beer"
    }
}
