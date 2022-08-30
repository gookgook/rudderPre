//
//  MyProfileViewController.swift
//  Rudder
//
//  Created by 박민호 on 2022/08/11.
//

import UIKit
import GameKit

class MyProfileViewController : UIViewController {
    
    let viewModel = MyProfileViewModel()
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
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
        self.performSegue(withIdentifier: "GoEditProfile", sender: nil)
    }
    
    @IBAction func touchUpTermsButton(_ sender: UIButton) {
        self.performSegue(withIdentifier: "ShowTerms", sender: nil)
    }
    
    @IBAction func touchUpFeedbackButton(_ sender: UIButton) {
        self.performSegue(withIdentifier: "GoFeedback", sender: nil)
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

extension MyProfileViewController: DoUpdateProfileDelegate {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let editProfileViewController: EditProfileViewController =
            segue.destination as? EditProfileViewController else {
            return
        }
        
        print("여기실행안됨?")
        
        editProfileViewController.currentProfileBody = viewModel.profile.partyProfileBody
        editProfileViewController.delegate = self
    }
    
    func doUpdateProfile() {
        let userInfoId = UserDefaults.standard.integer(forKey: "userInfoId")
        viewModel.requestProfile(userInfoId: userInfoId)
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
