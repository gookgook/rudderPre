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
    
    var numberOfApplicants: Int!
    
    @IBOutlet weak var scrollView: UIScrollView!
    

    @IBOutlet weak var partyThumbnailImageView: UIImageView!
    @IBOutlet weak var applyCountView: UIView!
    @IBOutlet weak var applyCountLabel: UILabel!
    
    /*@IBOutlet weak var alcoholView: UIView!
    @IBOutlet weak var alcoholImageView: UIImageView!
    @IBOutlet weak var alcoholName: UILabel!
    @IBOutlet weak var alcoholPriceLabel: UILabel!*/
    
    @IBOutlet weak var partyTitleView: UITextView!
    @IBOutlet weak var DateLabel: UILabel!
    @IBOutlet weak var LocationLabel: UILabel!
    
    @IBOutlet weak var PartyDescriptionView: UITextView!
    @IBOutlet weak var applyButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpBinding()
        viewModel.requestPartyDetail(partyId: partyId)
        
        //self.navigationController?.navigationBar.layer.zPosition = 1
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setBar()
        setStyle()
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
                    /*RequestImage.downloadImage(from: URL(string: partyDetail.alcoholImageUrl)!, imageView: self.alcoholImageView)*/
                    self.applyCountLabel.text = String(partyDetail.applyCount)
                    self.partyTitleView.text = partyDetail.partyTitle
                    self.DateLabel.text = String(Utils.stringDate(date: partyDetail.partyTime))
                    self.LocationLabel.text = partyDetail.partyLocation
                    self.PartyDescriptionView.text = partyDetail.partyDescription
                    //self.alcoholName.text = partyDetail.alcoholName
                    /*self.alcoholPriceLabel.text = "+ " + partyDetail.alcoholCurrency + String(partyDetail.alcoholPrice)
                    self.alcoholPriceLabel.text! +=  " / " + String(partyDetail.alcoholCount) + " " + partyDetail.alcoholUnit*/
                    if partyDetail.partyStatus != "NONE" {
                        self.applyButton.isEnabled = false
                        self.applyButton.backgroundColor = MyColor.superLightGray
                        self.applyButton.setTitle("Applied", for: .normal)
                    }
                }
            }
        }
        viewModel.applyResultFlag.bind{ [weak self] status in
            guard let self = self else {return}
            if status == 1 {
                DispatchQueue.main.async {
                    self.applyButton.isEnabled = false
                    self.applyButton.backgroundColor = MyColor.superLightGray
                    self.applyButton.setTitle("Applied", for: .normal)
                    self.applyCountLabel.text = String(Int(self.applyCountLabel.text!)! + self.numberOfApplicants )
                }
            }
        }
    }
}

extension PartyDetailViewController: DoApplyDelegate {
    
    @IBAction func touchUpApply(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "CustomAlerts", bundle: nil)

        let vc = storyboard.instantiateViewController(withIdentifier: "WithFriendsAlert") as! WithFriendsAlertViewController
        vc.delegate = self
        
        vc.modalPresentationStyle = .overCurrentContext
        tabBarController?.present(vc, animated: true, completion: nil)
    }
    
    func doApply(numberOfApplicants: Int) {
        self.numberOfApplicants = numberOfApplicants
        viewModel.requestApplyParty(numberApplicants: numberOfApplicants)
    }
}

extension PartyDetailViewController {
    func setBar(){
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.tabBarController?.tabBar.isHidden = true
        self.tabBarController?.tabBar.isTranslucent = true
        
        scrollView.contentInsetAdjustmentBehavior = .never // notchㄸ까지 채우기 위해서
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default) //UIImage.init(named: "transparent.png")
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        
        
    }
    func setStyle(){
        
        applyCountView.layer.borderWidth = 1
        applyCountView.layer.borderColor = UIColor.white.cgColor
    }
}
