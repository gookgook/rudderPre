//
//  SuViewController.swift
//  Rudder
//
//  Created by 박민호 on 2022/06/28.
//

import UIKit

class SignUpViewController: UIViewController {
    
    let viewModel = SignUpViewModel()
    
    private var fCurTextfieldBottom: CGFloat = 0.0
    
    @IBOutlet weak var scrollView: UIView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    @IBOutlet weak var uniEmailField: UITextField!
    @IBOutlet weak var userPasswordField: UITextField!
    
    @IBOutlet weak var passwordImage: UIImageView!
    @IBOutlet weak var IdImage: UIImageView!
    
    @IBOutlet weak var signUpButton: UIButton!
    var isFinished = IsFinished(uniEmail: false, password: false, terms: false)
    
    struct IsFinished {
        var uniEmail: Bool
        var password: Bool
        var terms: Bool
    }
    
}

extension SignUpViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        setUpBinding()
        setUIs()
        
        signUpButton.isEnabled = false
        signUpButton.backgroundColor = MyColor.superLightGray
        uniEmailField.addTarget(self, action: #selector(self.userIdFieldChanged), for: .editingChanged)
        userPasswordField.addTarget(self, action: #selector(self.userPasswordFieldChanged), for: .editingChanged)
    }
    
    @IBAction func touchUpSignUpButton(_ sender: UIButton){
        viewModel.userEmail = uniEmailField.text
        viewModel.userPassword = userPasswordField.text
        viewModel.sendValidateRequest()
    }

    @IBAction func touchUpTermButton(_ sender: UIButton){
        self.performSegue(withIdentifier: "ShowTerms", sender: nil)
    }
    
    @IBAction func touchUpAgreeButton(_ sender: UIButton){
        isFinished.terms = !isFinished.terms
        somethingChanged()
    }
}

extension SignUpViewController {
    func setUpBinding() {
        viewModel.nextButtonResultFlag.bind { [weak self] status in
            guard let self = self else {return}
            DispatchQueue.main.async { /*self.spinner.stopAnimating() */
                switch status {  // school name이 올 수도 있어서 오류상황들 앞에 놓고 그게 아니라면 school name 이 온걸로 간주해서 default에서 처리
                case nil: break
                case "2":  Alert.showAlert(title: ConstStrings.WRONG_EMAIL_FORM, message: nil, viewController: self)
                case "3":  Alert.showAlert(title: ConstStrings.EMAIL_ALREADY_EXISTS, message: nil, viewController: self)
                case "-1" : Alert.showAlert(title: "Server Error", message: nil, viewController: self)
                default :
                    //이부분에 school name alert로 띄워주자?
                    self.performSegue(withIdentifier: "GoSetProfile1", sender: nil)
                }
            }
        }
    }
}

extension SignUpViewController {
    func setBar(){
        self.navigationItem.hidesBackButton = true
        let label = UILabel()
        label.text = " Sign Up"
        label.textAlignment = .left
        label.font = UIFont(name: "SF Pro Text Bold", size: 20)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: label)
        
        let backButtonView = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 40, height: 40)))
        let backButton = UIButton(type: .system)
        backButton.frame = CGRect(origin: .zero, size: CGSize(width: 40, height: 40))
        backButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        backButton.addTarget(self, action: #selector(goBack(_:)), for: .touchUpInside)
        backButtonView.addSubview(backButton)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: backButtonView)
        
    }
    
    func setBarStyle(){
        self.navigationController?.navigationBar.tintColor = .black
        self.navigationController?.navigationBar.barTintColor = .white
        //self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for:.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.layoutIfNeeded()
    }
    
    @objc func goBack(_ sender: UIBarButtonItem){
        print("go Back touched")
        self.navigationController?.popViewController(animated: true)
    }
    
    func setUIs() {
        IdImage.image = nil
        passwordImage.image = nil
        
        uniEmailField.delegate = self
        userPasswordField.delegate = self
        
        uniEmailField.addLeftPadding(padding: 10)
        userPasswordField.addLeftPadding(padding: 10)
    }
}

extension SignUpViewController {
    func showToast(message : String, font: UIFont) {

        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 150, y: self.view.frame.origin.x+120/*self.view.frame.size.height-100*/, width: 300, height: 35))
        toastLabel.backgroundColor = MyColor.rudderPurple
        toastLabel.textColor = UIColor.white
        toastLabel.font = font
        toastLabel.textAlignment = .center;
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 1.0, delay: 1.0, options: .curveEaseOut, animations: {
             toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
    
    @IBAction func didTapAutoLogin(_ sender: UIButton) {
        sender.isSelected.toggle()
    }
}

extension SignUpViewController {
    @objc private func userIdFieldChanged(_ textField: UITextField) {
        
        self.showToast(message: " Enter your valid university email ", font: .systemFont(ofSize: 12.0))
        
        if uniEmailField.text!.count == 0 {
            isFinished.uniEmail = false
            IdImage.image = nil
        } else {
            isFinished.uniEmail = true
            IdImage.image = UIImage(named: "check")
        }
        somethingChanged()
    }
    
    @objc private func userPasswordFieldChanged(_ textField: UITextField) {
        
        isFinished.password = false
        if (textField.text!.count == 0){
            passwordImage.image = nil
        }else if (textField.text!.count<8){
            passwordImage.image = UIImage(named: "xCheck")
            self.showToast(message: " Your Password must be at least 8 character long ", font: .systemFont(ofSize: 12.0))
        }else{
            isFinished.password = true
            self.showToast(message: " success ", font: .systemFont(ofSize: 12.0))
            passwordImage.image = UIImage(named: "check")
            isFinished.password = true
        }
        
        somethingChanged()
    }
    
    private func somethingChanged(){
        signUpButton.isEnabled = false
        signUpButton.backgroundColor = MyColor.superLightGray
        signUpButton.removeGradient()
        if isFinished.uniEmail && isFinished.password && isFinished.terms{
            signUpButton.isEnabled = true
            signUpButton.applyGradient(colors: MyColor.gPurple)
        }
    }

}

extension SignUpViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let setProfile1ViewController: SetProfile1ViewController =
            segue.destination as? SetProfile1ViewController else {
            return
        }
        setProfile1ViewController.viewModel = viewModel
    }
}


extension SignUpViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("didbegin")
        fCurTextfieldBottom = textField.frame.origin.y + textField.frame.height
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        print("keyboardwillshow")
        /*if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if fCurTextfieldBottom <= self.scrollView.frame.height - keyboardSize.height {
                return
            }
            let cp = CGPoint(x: 0, y: keyboardSize.height + originalOffset)
            if self.scrollView.contentOffset.y == originalOffset {
                scrollView.setContentOffset(cp, animated: true)
            }
        }*/
        
    }
    @objc func keyboardWillHide(notification: NSNotification) {
        print("willresign")
        /*if scrollView.contentOffset.y != originalOffset{
            scrollView.contentOffset.y = originalOffset
        }*/
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

