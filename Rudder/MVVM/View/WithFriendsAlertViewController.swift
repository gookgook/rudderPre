//
//  WithFriendsAlertViewController.swift
//  Rudder
//
//  Created by 박민호 on 2022/07/25.
//

import UIKit

class WithFriendsAlertViewController: UIViewController {
    
    weak var delegate: DoApplyDelegate?
    
    @IBOutlet weak var numberField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func touchUpApplyButton(_ sender: UIButton){
        delegate?.doApply(numberOfApplicants: Int(numberField.text!)!)
        dismiss(animated: false, completion: nil)
    }
}
