//
//  ReportViewController.swift
//  Rudder
//
//  Created by 박민호 on 2022/09/01.
//

import UIKit

final class ReportViewController: UIViewController {
    
    @IBOutlet weak var reportBodyField: UITextField!
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    var userInfoId: Int!

    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func touchUpXButton(_ sender: UIButton){
        dismiss(animated: false, completion: nil)
    }

    
    @IBAction func touchUpSubmitButton(_ sender: UIButton){
        
        guard let reportBody = reportBodyField.text else {
            Alert.showAlert(title: "One or more fields are empty!", message: nil, viewController: self)
            return
        }
        
        RequestReport.uploadInfo(itemId: userInfoId, reportBody: reportBody, reportType: "USER") {status in
            DispatchQueue.main.async {
                if status == 1 {
                
                    Alert.showAlertWithCB(title: "Thaks for the Feedback. We will take it from here" , message: nil, isConditional: false, viewController: self) {_ in
                        self.dismiss(animated: false, completion: nil)
                    }

                } else {
                    Alert.showAlertWithCB(title: "Server Error" , message: nil, isConditional: false, viewController: self) {_ in
                        self.dismiss(animated: false, completion: nil)
                    }
                }
            }
        }
        
    }
}

extension ReportViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
