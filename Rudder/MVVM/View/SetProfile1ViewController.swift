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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUIs()
    }
}

extension SetProfile1ViewController {
    @IBAction func touchUpSignUpButton(_ sender: UIButton){
        guard (nickNameField.text?.isEmpty == false && profileBodyView.text?.isEmpty == false) else {
            Alert.showAlert(title: "One or more fields are empty", message: nil, viewController: self)
            return
        }
        viewModel?.userNickname = nickNameField.text
        viewModel?.userProfileBody = profileBodyView.text
        self.performSegue(withIdentifier: "GoSetProfile2", sender: sender)
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
