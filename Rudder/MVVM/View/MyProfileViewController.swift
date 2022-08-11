//
//  MyProfileViewController.swift
//  Rudder
//
//  Created by 박민호 on 2022/08/11.
//

import UIKit

class MyProfileViewController : UIViewController {
    
    let viewModel = MyProfileViewModel()
    
    @IBOutlet weak var profileView: UIView!
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var universityLogoView: UIImageView!
    
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var profileBodyView: UITextView!
    
    @IBOutlet weak var editButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpBinding()
    }
}

extension MyProfileViewController {
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
    }
}
