//
//  PreSettingViewController.swift
//  Rudder
//
//  Created by 박민호 on 2022/08/13.
//

import UIKit

class PreSettingViewController: UIViewController {

    @IBOutlet weak var partyThumbnailViewL: UIImageView!
    
    @IBOutlet weak var cancellationButton: ButtonView!
    @IBOutlet weak var stopRecruitButton: ButtonView!
    @IBOutlet weak var FixMemberButton: ButtonView!
    @IBOutlet weak var ProblemButton: ButtonView!
    @IBOutlet weak var EnquirynButton: ButtonView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension PreSettingViewController {
    func addGesturesToButton(){
        
    }
}

