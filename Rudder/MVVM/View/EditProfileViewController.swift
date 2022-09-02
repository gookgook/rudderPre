//
//  EditProfileViewController.swift
//  Rudder
//
//  Created by 박민호 on 2022/08/24.
//

import UIKit

class EditProfileViewController: UIViewController {

    let viewModel = EditProfileViewModel()
    
    weak var delegate: DoUpdateProfileDelegate!
    
    @IBOutlet weak var profileBodyView: UITextView!
    
    var currentProfileBody: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpBinding()
        hideKeyboardWhenTappedAround()
        profileBodyView.text = currentProfileBody
    }
}

extension EditProfileViewController {
    func setUpBinding(){
        viewModel.editResultFlag.bind { [weak self] status in
            guard let self = self else {return}
            DispatchQueue.main.async {
                switch status {
                case 1 :
                    self.delegate?.doUpdateProfile()
                    self.navigationController?.popViewController(animated: true)
                case 2 : Alert.showAlert(title: "profile Body Count", message: nil, viewController: self)
                default: Alert.showAlert(title: "Server Error", message: nil, viewController: self)
                }
            }
        }
    }
}

extension EditProfileViewController {
    @IBAction func touchUpDoneButton(_ sender: UIButton) {
        viewModel.profileBody = profileBodyView.text
        viewModel.requestEditProfile()
    }
}

extension EditProfileViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
