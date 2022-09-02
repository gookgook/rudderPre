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
    
    let pickerView = UIPickerView()
    
    let possibleNumber = [0,1,2,3,4]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        numberField.tintColor = .clear
        setParticipantsPicker()
    }
    
    @IBAction func touchUpApplyButton(_ sender: UIButton){
        
        guard let participantNumber = Int(numberField.text!) else {
            Alert.showAlert(title: "One or more fields are empty!", message: nil, viewController: self)
            return
        }
        
        delegate?.doApply(numberOfApplicants: participantNumber)
        dismiss(animated: false, completion: nil)
    }
    
    @IBAction func touchUpXButton(_ sender: UIButton){
        dismiss(animated: false, completion: nil)
    }
}

extension WithFriendsAlertViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        possibleNumber.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if row == 0 {
            return "0 (Just You)"
        }
        return String(possibleNumber[row])
    }
    
    func setParticipantsPicker() {
        numberField.text = "Select"
        
        pickerView.delegate = self
        numberField.inputView = pickerView
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let tmpBarButton = UIBarButtonItem(title: "Select", style: .plain, target: self, action: #selector(self.done))
        tmpBarButton.tintColor = MyColor.rudderPurple
        let button = tmpBarButton
        toolBar.setItems([button], animated: true)
        toolBar.isUserInteractionEnabled = true
        numberField.inputAccessoryView = toolBar
    }
    
    @objc func done(){
            
        numberField.text = String(possibleNumber[pickerView.selectedRow(inComponent: 0)])
        numberField.endEditing(true)
    }
}
