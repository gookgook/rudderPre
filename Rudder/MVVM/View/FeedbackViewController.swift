//
//  FeedbackViewController.swift
//  Rudder
//
//  Created by Brian Bae on 12/09/2021.
//

import UIKit

final class FeedbackViewController: UIViewController {
    
    let viewModel = FeedbackViewModel()
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var feedbackBodyView: UITextView!
    
    @IBOutlet weak var submitButton: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        setUpBinding()
        placeholderSetting()
        setUIs()
    }
}

extension FeedbackViewController {
    func setUpBinding() {
        viewModel.sendFeedbackResultFlag.bind { [weak self] status in
            guard let self = self else {return}
            DispatchQueue.main.async {
                switch status {
                case 1:
                    Alert.showAlertWithCB(title: "Thanks for the Feedback. We will take it from here", message: nil, isConditional: false, viewController: self, completionBlock: {_ in
                        self.navigationController?.popViewController(animated: true)
                        self.dismiss(animated: true, completion: nil)
                    })
                case 2:
                    Alert.showAlert(title: "One or more fields are empty", message: nil, viewController: self)
                default:
                    Alert.showAlert(title: "server error", message: nil, viewController: self)
                }
            }
        }
        viewModel.isLoadingFlag.bind{ [weak self] status in
            guard let self = self else {return}
            DispatchQueue.main.async {
                if status {
                    LoadingScreen.shared.showLoadingPage(_view: self)
                    self.view.isUserInteractionEnabled = false
                }
                else {
                    LoadingScreen.shared.hideLoadingPage(_view: self)
                    self.view.isUserInteractionEnabled = true
                }
            }
        }
    }
}

extension FeedbackViewController {
    @IBAction func touchUpSubmitButton(_ sender: UIButton){
        viewModel.feedbackBody = feedbackBodyView.text
        viewModel.requestFeedback()
    }
}

extension FeedbackViewController: UITextViewDelegate {
    func placeholderSetting() {
        feedbackBodyView.textContainerInset = UIEdgeInsets(top: 5, left: 7, bottom: 5, right: 7) //얘는 사실 따로 빼자 관련없으니까
        
        feedbackBodyView.delegate = self // txtvReview가 유저가 선언한 outlet
        feedbackBodyView.text = "Send us any comments, questions, or suggestions."
        feedbackBodyView.textColor = UIColor.lightGray
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        if feedbackBodyView.textColor == UIColor.lightGray {
            feedbackBodyView.text = nil
            feedbackBodyView.textColor = UIColor.black
        }
        
    }
    // TextView Place Holder
    func textViewDidEndEditing(_ textView: UITextView) {
        if feedbackBodyView.text.isEmpty {
            feedbackBodyView.text = "Send us any comments, questions, or suggettions."
            feedbackBodyView.textColor = UIColor.lightGray
        }
    }
}


extension FeedbackViewController {
    func hideKeyboardWhenTappedAround() {
        /*let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)*/
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func setUIs(){
        submitButton.applyGradient(colors: MyColor.gPurple)
    }
}
