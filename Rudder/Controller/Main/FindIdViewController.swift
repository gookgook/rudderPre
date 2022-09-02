//
//  FindIdViewController.swift
//  Rudder
//
//  Created by 박민호 on 2022/02/13.
//

import UIKit

class FindIdViewController: UIViewController {
    @IBOutlet weak var emailField: UITextField!
    
    @IBAction func touchUpSendButton(_ sender: UIButton){
        print("Send Button touched")
        guard let email: String = self.emailField.text,
              email.isEmpty == false else {
            Alert.showAlert(title: "Email Field Empty!", message: nil, viewController: self)
            return
        }
        RequestSendId.uploadInfo(email: email, completion: {
            status in
            if status {
                Alert.showAlertWithCB(title: "We have sent your ID to your school email", message: nil, isConditional: false, viewController: self, completionBlock: {_ in
                    self.navigationController?.popToRootViewController(animated: true)
                })
            }else{
                Alert.showAlert(title: "Please enter your valid school email", message: nil, viewController: self)
            }
        })
        
    }
}
extension FindIdViewController {

    override func viewDidLoad() {
        
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        setBar()
    }

    func setBar(){
        self.navigationController?.navigationBar.tintColor = UIColor.white
    }
}

extension FindIdViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
