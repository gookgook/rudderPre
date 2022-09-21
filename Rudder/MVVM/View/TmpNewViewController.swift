//
//  TmpNewViewController.swift
//  Rudder
//
//  Created by 박민호 on 2022/07/14.
//

import UIKit

class TmpNewViewController: UIViewController {
    
    weak var delegate: DoUpdateAcceptButtonDelegate?
    
    @IBOutlet weak var closeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        closeButton.applyGradient(colors: MyColor.gPurple)
    }
    
    @IBAction func touchUpXButton(_ sender: UIButton){
        dismiss(animated: false, completion: nil)
    }
    
    @IBAction func touchUpCloseButton(_sender: UIButton){
        dismiss(animated: false, completion: nil)
        delegate?.doUpdateAcceptButton()
    }
    
}
