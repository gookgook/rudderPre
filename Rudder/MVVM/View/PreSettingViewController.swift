//
//  PreSettingViewController.swift
//  Rudder
//
//  Created by 박민호 on 2022/08/13.
//

import UIKit

class PreSettingViewController: UIViewController {
    
    let viewModel = PreSettingViewModel()
    
    var partyThumbnailImageURL: String!

    @IBOutlet weak var partyThumbnailView: UIImageView!
    
    @IBOutlet weak var cancellationButton: ButtonView!
    @IBOutlet weak var stopRecruitButton: ButtonView!
    @IBOutlet weak var FixMemberButton: ButtonView!
    @IBOutlet weak var ProblemButton: ButtonView!
    @IBOutlet weak var EnquiryButton: ButtonView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        RequestImage.downloadImage(from: URL(string: partyThumbnailImageURL)!, imageView: partyThumbnailView)
    }
}

extension PreSettingViewController {
    func addGesturesToButton(){
        cancellationButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(touchUpCancellationButton(_:))))
        stopRecruitButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(touchUpCancellationButton(_:))))
        FixMemberButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(touchUpCancellationButton(_:))))
        ProblemButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(touchUpCancellationButton(_:))))
        EnquiryButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(touchUpCancellationButton(_:))))
    }
}

extension PreSettingViewController {
    @objc func touchUpCancellationButton(_ sender: UIButton){
        
    }
    @objc func touchUpStopRecruitButton(_ sender: UIButton){
        
    }
    @objc func touchUpFixMemberButton(_ sender: UIButton){
        
    }
    @objc func touchUpProblemButton(_ sender: UIButton){
        
    }
    @objc func touchUpEnquiryButton(_ sender: UIButton){
        
    }
}
