//
//  PartyDetailViewController.swift
//  Rudder
//
//  Created by 박민호 on 2022/07/25.
//

import UIKit

class PartyDetailViewController: UIViewController {
    
    let viewModel = PartyDetailViewModel()
    
    var partyId: Int!

    @IBOutlet weak var partyThumbnailImageView: UIImageView!
    @IBOutlet weak var applyCountLabel: UILabel!
    
    @IBOutlet weak var partyTitleView: UITextView!
    @IBOutlet weak var DateLabel: UILabel!
    @IBOutlet weak var LocationLabel: UILabel!
    
    @IBOutlet weak var PartyDescriptionView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpBinding()
        viewModel.requestPartyDetail(partyId: partyId)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setBar()
    }
}

extension PartyDetailViewController {
    func setUpBinding(){
        viewModel.getPartyDetailFlag.bind{ [weak self] status in
            guard let self = self else {return}
            if status == 1 {
                let partyDetail = self.viewModel.partyDetail!
                
                DispatchQueue.main.async {
                RequestImage.downloadImage(from: URL(string: partyDetail.partyThumbnailUrl)!, imageView: self.partyThumbnailImageView )
                    self.applyCountLabel.text = String(partyDetail.applyCount) + " Applied"
                    self.partyTitleView.text = partyDetail.partyTitle
                    self.DateLabel.text = String(Utils.timeAgo(postDate: partyDetail.partyTime))
                    self.LocationLabel.text = partyDetail.partyLocation
                    self.PartyDescriptionView.text = partyDetail.partyDescription
                }
            }
        }
    }
}

extension PartyMainViewController: DoApplyDelegate {
    
    @IBAction func touchUpApply(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "CustomAlerts", bundle: nil)

        let vc = storyboard.instantiateViewController(withIdentifier: "WithFriend") as! WithFriendsAlertViewController
        vc.delegate = self
        
        vc.modalPresentationStyle = .overCurrentContext
        tabBarController?.present(vc, animated: true, completion: nil)
    }
    
    func doApply() {
        <#code#>
    }
}

extension PartyDetailViewController {
    func setBar(){
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.tabBarController?.tabBar.isHidden = true
        self.tabBarController?.tabBar.isTranslucent = true
    }
}
