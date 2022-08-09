//
//  ProfileViewController.swift
//  Rudder
//
//  Created by 박민호 on 2022/08/08.
//

import UIKit

class ProfileViewController: UIViewController {
    
    let viewModel = ProfileViewModel()
    
    var applicant: PartyApplicant!
    var partyId: Int!
    
    @IBOutlet weak var profileView: UIView!
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var universityLogoView: UIImageView!
    
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var profileBodyView: UITextView!
    
    @IBOutlet weak var acceptButton: UIButton!
    
    @IBAction func touchUpAcceptButton(_ sender: UIButton){
        viewModel.requestAcceptApplicant(partyId: partyId, partyMemberId: applicant.partyMemberId)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUIs()
        setUpBinding()
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
                    RequestImage.downloadImage(from: URL(string: profile.partyProfileImages[0])!, imageView: self.profileImageView)
                    self.nicknameLabel.text = profile.userNickname
                    self.profileBodyView.text = profile.partyProfileBody
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
                vc.modalPresentationStyle = .overCurrentContext
                self.tabBarController?.present(vc, animated: true, completion: nil)
            }
            
        }
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
        
    }
}
