//
//  SetProfile1ViewController.swift
//  Rudder
//
//  Created by 박민호 on 2022/07/28.
//

import UIKit

class SetProfile1ViewController: UIViewController {
    
    var viewModel: SignUpViewModel? //signUpViewController에서 넘겨줄거임

    @IBOutlet weak var nickNameField: UITextField!
    @IBOutlet weak var profileBodyView: UITextView!
    
    @IBOutlet weak var signUpButton: UIButton!
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUIs()
        setBinding()
        hideKeyboardWhenTappedAround()
    }
}

extension SetProfile1ViewController {
    func setBinding() {
        viewModel?.goNextPageResultFlag.bind{[weak self] status in
            guard let self = self else {return}
            switch status {
            case 1: self.performSegue(withIdentifier: "GoSetProfile2", sender: nil)
            case 2: Alert.showAlert(title: "One or more Fields are empty!", message: nil, viewController: self)
            case 3 : Alert.showAlert(title: "Description must be at least 20 characters long", message: nil, viewController: self)
            default: return
            }
        }
        viewModel?.isLoadingFlag.bind{ [weak self] status in
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

extension SetProfile1ViewController {
    @IBAction func touchUpSignUpButton(_ sender: UIButton){
        viewModel?.userNickname = nickNameField.text
        viewModel?.userProfileBody = profileBodyView.text
        viewModel?.touchUpNextButton()
    }
}

extension SetProfile1ViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let setProfile2ViewController: SetProfile2ViewController =
            segue.destination as? SetProfile2ViewController else {
            return
        }
        setProfile2ViewController.viewModel = viewModel
    }
}
    
extension SetProfile1ViewController {
    func setUIs(){
        nickNameField.addLeftPadding(padding: 10)
        profileBodyView.textContainer.lineFragmentPadding = 10
        signUpButton.applyGradient(colors: MyColor.gPurple)
        hideKeyboardWhenTappedAround()
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
