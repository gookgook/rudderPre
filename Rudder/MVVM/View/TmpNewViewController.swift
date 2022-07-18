//
//  TmpNewViewController.swift
//  Rudder
//
//  Created by 박민호 on 2022/07/14.
//

import UIKit

class TmpNewViewController: UIViewController {
    
    weak var delegate: GoSomePageDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func touchUpCloseButton(_sender: UIButton){
        delegate?.goSomePage()
        dismiss(animated: false, completion: nil)
        
    }
}
