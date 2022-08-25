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
    var partyId: Int!

    @IBOutlet weak var partyThumbnailView: UIImageView!
    
    @IBOutlet weak var cancellationButton: ButtonView!
    @IBOutlet weak var stopRecruitButton: ButtonView!
    @IBOutlet weak var FixMemberButton: ButtonView!
    @IBOutlet weak var ProblemButton: ButtonView!
    @IBOutlet weak var EnquiryButton: ButtonView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpBinding()
        addGesturesToButton()
        RequestImage.downloadImage(from: URL(string: partyThumbnailImageURL)!, imageView: partyThumbnailView)
    }
}

extension PreSettingViewController {
    func setUpBinding(){
        viewModel.stopRecruiFlag.bind{ [weak self] status in
            guard let self = self else {return}
            DispatchQueue.main.async {
                switch status {
                case 1 : Alert.showAlert(title: "Recruitment Stopped", message: nil, viewController: self)
                default : Alert.showAlert(title: "Server Error", message: nil, viewController: self)
                }
            }
        }
        viewModel.cancellationFlag.bind{ [weak self] status in
            guard let self = self else {return}
            DispatchQueue.main.async {
                switch status {
                case 1 :
                    Alert.showAlertWithCB(title: "Party Cancelled", message: nil, isConditional: false, viewController : self) {_ in
                        self.navigationController?.popViewController(animated: true)
                    }
                case 2: Alert.showAlert(title: "You can't cancel the party if there is one or more Participants", message: nil, viewController: self)
                default : Alert.showAlert(title: "Server Error", message: nil, viewController: self)
                }
            }
        }
        viewModel.fixTheMembersFlag.bind{ [weak self] status in
            guard let self = self else {return}
            DispatchQueue.main.async {
                switch status {
                case 1: Alert.showAlert(title: "Member fixed" , message: nil, viewController: self)
                default: Alert.showAlert(title: "Server Error", message: nil, viewController: self)
                }
            }
        }
    }
}

extension PreSettingViewController {
    func addGesturesToButton(){
        cancellationButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(touchUpCancellationButton(_:))))
        stopRecruitButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(touchUpStopRecruitButton(_:))))
        FixMemberButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(touchUpFixMemberButton(_:))))
        ProblemButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(touchUpProblemButton(_:))))
        EnquiryButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(touchUpEnquiryButton(_:))))
    }
}

extension PreSettingViewController {
    @objc func touchUpCancellationButton(_ sender: ButtonView){
        viewModel.requestCancellation(partyId: partyId)
    }
    @objc func touchUpStopRecruitButton(_ sender: ButtonView){
        viewModel.requestStopRecruit(partyId: partyId)
    }
    @objc func touchUpFixMemberButton(_ sender: ButtonView){
        viewModel.requestFixMembers(partyId: partyId)
    }
    @objc func touchUpProblemButton(_ sender: ButtonView){
        
    }
    @objc func touchUpEnquiryButton(_ sender: ButtonView){
        
    }
}
