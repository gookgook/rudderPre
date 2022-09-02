//
//  PartyFeedbackViewController.swift
//  Rudder
//
//  Created by 박민호 on 2022/08/25.
//

import UIKit

class PartyFeedbackViewController: UIViewController {
    
    let viewModel = PartyFeedbackViewModel()
    
    var partyId: Int!
    
    var feedbackType: String!
    var placeHolderString: String!
    
    @IBOutlet weak var feedbackTypeLabel: UILabel!
    @IBOutlet weak var feedbackBodyView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setFeedbackType()
        setUpBinding()
        hideKeyboardWhenTappedAround()
    }
    
    @IBAction func touchUpDoneButton(_ sender : UIButton) {
        viewModel.feedbackBody = feedbackBodyView.text
        viewModel.feedbackType = feedbackType
        viewModel.requestFeedback(partyId: partyId)
    }
}

extension PartyFeedbackViewController {
    func setUpBinding(){
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
    }
}

extension PartyFeedbackViewController {
    func setFeedbackType() {
        feedbackTypeLabel.text = feedbackType
        if feedbackType == "problem" {
            placeHolderString = "Tell us if there is a problem hosting a pre"
        } else {
            placeHolderString = "Tell us if you have any questions about hosting a pre"
        }
    }
}

extension PartyFeedbackViewController: UITextViewDelegate {
    func placeholderSetting() {
        feedbackBodyView.delegate = self // txtvReview가 유저가 선언한 outlet
        feedbackBodyView.text = placeHolderString
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
            feedbackBodyView.text = placeHolderString
            feedbackBodyView.textColor = UIColor.lightGray
        }
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
