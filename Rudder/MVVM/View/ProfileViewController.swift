//
//  ProfileViewController.swift
//  Rudder
//
//  Created by 박민호 on 2022/08/08.
//

import UIKit

class ProfileViewController: UIViewController {
    
    let viewModel = ProfileViewModel()
    
    weak var delegate: DoGoChatRoomDelegate?
    weak var refreshMyPreDelegate: DoRefreshMyPreDelegate?
    
    var applicant: PartyApplicant! //모종의 이유로 앞화면에서 받아옴
    var partyId: Int!
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    @IBOutlet weak var profileView: UIView!
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var universityLogoView: UIImageView!
    
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var profileBodyView: UITextView!
    
    @IBOutlet weak var acceptButton: UIButton!
    @IBOutlet weak var messageButton: UIButton!
    
    @IBOutlet weak var imageCountLabel: UILabel!
    
    @IBAction func touchUpAcceptButton(_ sender: UIButton){
        print("partyId")
        
        viewModel.requestAcceptApplicant(partyId: partyId, partyMemberId: applicant.partyMemberId)
    }
    
    @IBAction func touchUpMessageButton(_ sender: UIButton){
        viewModel.requestSendMessage(partyId: partyId, applicantUserInfoId: applicant.userInfoId)
    }
    
    @IBAction func touchUpReportButton(_ ssender: UIBarButtonItem) {
        print("touch report")
        let storyboard = UIStoryboard(name: "CustomAlerts", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ReportVC") as! ReportViewController
        vc.modalPresentationStyle = .overCurrentContext
        vc.userInfoId = applicant.userInfoId
        self.tabBarController?.present(vc, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUIs()
        setUpBinding()
        setImageSwipe()
        viewModel.requestProfile(userInfoId: applicant.userInfoId)
    }
}

extension ProfileViewController {
    func setUpBinding(){
        viewModel.getProfileFlag.bind{[weak self] status in
            guard let self = self else {return}
            if status == 1 {
                let profile = self.viewModel.profile!
                DispatchQueue.main.async {
                    RequestImage.downloadImage(from: URL(string: profile.schoolImageUrl)!, imageView: self.universityLogoView)
                    
                    
                    print(self.viewModel.currentImageNo.value)
                    
                    RequestImage.downloadImage(from: URL(string: profile.partyProfileImages[self.viewModel.currentImageNo.value])!, imageView: self.profileImageView)
                    self.nicknameLabel.text = profile.userNickname
                    self.profileBodyView.text = profile.partyProfileBody
                    self.imageCountLabel.text =  "1 / " + String(self.viewModel.profile.partyProfileImages.count)
                    if self.applicant.isChatExist {
                        self.messageButton.isEnabled = false
                        self.messageButton.backgroundColor = MyColor.superLightGray
                    }
                }
            }
        }
        viewModel.acceptResultFlag.bind{[weak self] status in
            guard let self = self else {return}
            guard status == 1 else {
                DispatchQueue.main.async { Alert.showAlert(title: "Server Error", message: nil, viewController: self) }
                return
            }
            DispatchQueue.main.async {
                let storyboard = UIStoryboard(name: "CustomAlerts", bundle: nil)

                let vc = storyboard.instantiateViewController(withIdentifier: "tmpNew") as! TmpNewViewController
                //vc.delegate = self
                vc.delegate = self
                vc.modalPresentationStyle = .overCurrentContext
                self.tabBarController?.present(vc, animated: true, completion: nil)
            }
            
        }
        viewModel.sendMessageFlag.bind{[weak self] chatRoomId in
            guard let self = self else {return}
            guard let chatRoomId = chatRoomId else {
                DispatchQueue.main.async { Alert.showAlert(title: "Server Error", message: nil, viewController: self) }
                return
            }
            DispatchQueue.main.async {
                
                self.navigationController?.popViewController(animated: true)
                self.delegate?.doGoChatRoomDelegate(chatRoomId: chatRoomId)
            }
        }
        viewModel.currentImageNo.bind{[weak self] currentImageNo in
            guard let self = self else {return}
            self.imageCountLabel.text = String(currentImageNo + 1) + " / " + String(self.viewModel.profile.partyProfileImages.count)
            RequestImage.downloadImage(from: URL(string: self.viewModel.profile.partyProfileImages[currentImageNo])!, imageView: self.profileImageView)
        }
        viewModel.isLoadingFlag.bind{ [weak self] status in
            guard let self = self else {return}
            DispatchQueue.main.async {
                if status {
                    self.spinner.startAnimating()
                    self.view.isUserInteractionEnabled = false
                }
                else {
                    self.spinner.stopAnimating()
                    self.view.isUserInteractionEnabled = true
                }
            }
        }
    }
}

extension ProfileViewController: DoUpdateAcceptButtonDelegate {
    func doUpdateAcceptButton() {
        acceptButton.setTitle("Accepted", for: .normal)
        acceptButton.backgroundColor = MyColor.superLightGray
        acceptButton.isEnabled = false
        self.refreshMyPreDelegate?.doRefreshMyPre()
    }
}

extension ProfileViewController {
    func setImageSwipe(){
        profileImageView.isUserInteractionEnabled = true
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(imageSwipeRight(_:)))
        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
        profileImageView.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(imageSwipeLeft(_:)))
        swipeLeft.direction = UISwipeGestureRecognizer.Direction.left
        profileImageView.addGestureRecognizer(swipeLeft)
    }
    
    @objc func imageSwipeLeft(_ gesture: UIGestureRecognizer){
        viewModel.handleImageSwipe(direction: 1) //1 = left
    }
    
    @objc func imageSwipeRight(_ gesture: UIGestureRecognizer){
        viewModel.handleImageSwipe(direction: 2) // 2 = right
    }
}


extension ProfileViewController {
    func setUIs(){
        
        ColorDesign.setShadow(view: profileView)
        
        universityLogoView.layer.zPosition = 1
        
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.tabBarController?.tabBar.isHidden = true
        self.tabBarController?.tabBar.isTranslucent = true
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default) //UIImage.init(named: "transparent.png")
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        self.navigationController?.navigationBar.tintColor = UIColor.black
        
    }
}
