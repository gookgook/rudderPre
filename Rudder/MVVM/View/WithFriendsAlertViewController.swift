//
//  WithFriendsAlertViewController.swift
//  Rudder
//
//  Created by 박민호 on 2022/07/25.
//

import UIKit

class WithFriendsAlertViewController: UIViewController {
    
    weak var delegate: DoApplyDelegate?
    
    @IBOutlet weak var applyButton: UIButton!
    @IBOutlet weak var numberField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func touchUpApplyButton(_sender: UIButton){
        dismiss(animated: false, completion: nil)
        delegate?.doApply()
    }
}
