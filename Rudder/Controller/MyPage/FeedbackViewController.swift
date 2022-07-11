//
//  FeedbackViewController.swift
//  Rudder
//
//  Created by Brian Bae on 12/09/2021.
//

import UIKit

class FeedbackViewController: UIViewController {
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    @IBOutlet weak var feedbackBodyView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()
        
        feedbackBodyView.tintColor = MyColor.rudderPurple
        placeholderSetting()
    }
}

extension FeedbackViewController {
    @IBAction func touchUpSubmitButton(_ sender: UIButton){
        spinner.startAnimating()
        print("Report Submit Touched")
        guard let feedbackBody: String = self.feedbackBodyView.text,
            feedbackBody.isEmpty == false else {
            print("feedback empty")
            return
        }
        
        RequestFeedback.uploadInfo(feedbackBody: feedbackBody, completion: {
            status in
            DispatchQueue.main.async {self.spinner.stopAnimating()}
            if status == 1 {
                print("send feedback success")
                DispatchQueue.main.async {
                    Alert.showAlertWithCB(title: "Thanks for the Feedback. We will take it from here", message: nil, isConditional: false, viewController: self, completionBlock: {_ in
                        self.navigationController?.popViewController(animated: true)
                        self.dismiss(animated: true, completion: nil)
                    })
                }
            }
            if status == 2 {
                print("send feedback error")
            }
        })
    }
}

extension FeedbackViewController {
    @IBAction func goBack(_ sender: UIButton){
        print("go Back touched")
        self.navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
}

extension FeedbackViewController: UITextViewDelegate {
    func placeholderSetting() {
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
}
