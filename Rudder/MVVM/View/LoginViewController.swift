//
//  LoViewController.swift
//  Rudder
//
//  Created by 박민호 on 2022/06/02.
//

import UIKit

class LoginViewController: UIViewController {
    
    let viewModel = LoginViewModel()
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!

    @IBOutlet weak var userIdField: UITextField!
    @IBOutlet weak var userPasswordField: UITextField!
    
}

extension LoginViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showNotice()
        setUpViews()
        setUpBinding()
//        gradientButton.applyGradient(colors: [UIColor.white.cgColor,UIColor.purple.cgColor])
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        self.tabBarController?.tabBar.isTranslucent = true
        self.tabBarController?.tabBar.isHidden = true
        
        userIdField.text = nil
        userPasswordField.text = nil
    }
    
}

extension LoginViewController {
    func setUpViews () {
        spinner.hidesWhenStopped = true
        hideKeyboardWhenTappedAround()
    }
    
    func setUpBinding() {
        viewModel.loginResultFlag.bind { [weak self] status in
            guard let self = self else { return }
            DispatchQueue.main.async { self.spinner.stopAnimating() }
            switch status {
            case nil : break
            case 1 : DispatchQueue.main.async {self.performSegue(withIdentifier: "GoPartyMain", sender: nil)}
            case 2 : DispatchQueue.main.async { Alert.showAlert(title: "Verify your account through your university email", message: nil, viewController: self) }
            case 3, 4 : DispatchQueue.main.async { Alert.showAlert(title: "Wrong", message: nil, viewController: self) }
            case 5 : DispatchQueue.main.async { Alert.showAlert(title: "One or more field is empty", message: nil, viewController: self) }
            case -1 : DispatchQueue.main.async { Alert.showAlert(title: "Server Error", message: nil, viewController: self) }
            default : DispatchQueue.main.async { Alert.showAlert(title: "Unknown Error", message: nil, viewController: self) }
            }
        }
    }
    
    @IBAction func touchUpLoginButton(_ sender: UIButton){
        self.spinner.startAnimating()
        viewModel.userEmail = userIdField.text
        viewModel.userPassword = userPasswordField.text
        viewModel.sendLoginRequest()
    }
}

extension LoginViewController {
    @IBAction func touchUpForgotButton(_ sender: UIButton){
        
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let forgotIdAction = UIAlertAction(title: "Forgot ID", style: .default, handler: { action in
            print("forgotId called")
            self.performSegue(withIdentifier: "GoForgotID", sender: sender)
        })
        
        let forgotPasswordAction = UIAlertAction(title: "Forgot Password", style: .default, handler: { action in
            print("forgotPassword called")
            self.performSegue(withIdentifier: "GoForgotPW", sender: sender)
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        actionSheet.addAction(forgotIdAction)
        actionSheet.addAction(forgotPasswordAction)
        actionSheet.addAction(cancelAction)
        self.present(actionSheet, animated: true, completion: nil)
    }
}

extension LoginViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension LoginViewController {
    func showNotice(){
        if Utils.noticeShowed == false && Utils.firstScreen == 0{
            Alert.serverAlert(viewController: self)
            Utils.noticeShowed = true
        }
    }
}
