//
//  MyProfileViewController.swift
//  Rudder
//
//  Created by 박민호 on 2022/08/11.
//

import UIKit

class MyProfileViewController : UIViewController {
    
    let viewModel = MyProfileViewModel()
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var profileView: UIView!
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var universityLogoView: UIImageView!
    
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var profileBodyView: UITextView!
    
    @IBOutlet weak var editButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpBinding()
        setBar()
        setStyle()
        let userInfoId = UserDefaults.standard.integer(forKey: "userInfoId")
        viewModel.requestProfile(userInfoId: userInfoId)
    }
}

extension MyProfileViewController {
    @IBAction func touchUpEditButton(_ sender: UIButton){
        Alert.showAlert(title: "Wait for Next Update!", message: nil, viewController: self)
    }
    
    @IBAction func touchUpLogout(_ sender: UIButton){
        Alert.showAlertWithCB(title: "Are you sure you want to logout?", message: nil, isConditional: true, viewController: self, completionBlock: {status in
            if status {
                UserDefaults.standard.removeObject(forKey: "token")
                UserDefaults.standard.removeObject(forKey: "userInfoId")
                self.navigationController?.popToRootViewController(animated: false)
            }
        })
    }
}

extension MyProfileViewController {
    func setUpBinding(){
        viewModel.getProfileFlag.bind{[weak self] status in
            guard let self = self else {return}
            if status == 1 {
                let profile = self.viewModel.profile!
                DispatchQueue.main.async {
                    self.profileImageView.contentMode = .scaleToFill
                    RequestImage.downloadImage(from: URL(string: profile.schoolImageUrl)!, imageView: self.universityLogoView)
                    RequestImage.downloadImage(from: URL(string: profile.partyProfileImages[0])!, imageView: self.profileImageView)
                    self.nicknameLabel.text = profile.userNickname
                    self.profileBodyView.text = profile.partyProfileBody
                }
            }
        }
    }
}

extension MyProfileViewController {
    func setBar(){
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.tabBarController?.tabBar.isHidden = true
        self.tabBarController?.tabBar.isTranslucent = true
        
        scrollView.contentInsetAdjustmentBehavior = .never
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default) //UIImage.init(named: "transparent.png")
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        
    }
    
    func setStyle(){
        ColorDesign.setShadow(view: profileView)
    }
}
