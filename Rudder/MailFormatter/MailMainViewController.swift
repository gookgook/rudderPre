//
//  MailMainViewController.swift
//  Rudder
//
//  Created by 박민호 on 2022/12/21.
//

import UIKit

class MailMainViewController: UIViewController {
    
    
    @IBOutlet weak var inputMailTextView: UITextView!
    @IBOutlet weak var outputMailTextView: UITextView!
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    @IBAction func touchUpSendButton(_ sender: UIButton){
        print("touch Up Send")
        spinner.startAnimating()
        RequestMailService.uploadInfo(email: inputMailTextView.text!) {
            doubleBody in
            print("파파고결과" + doubleBody)
            self.autoGptButton(body: doubleBody)
            DispatchQueue.main.async {
                
                self.outputMailTextView.text = doubleBody
            }
        }
        
    }
    
    @IBAction func touchUpGptButton(_ sender: UIButton){
        print("touch Up Gpt")
        
        let realBody = "이 이메일을 예의바른 영어로 바꿔줘\n\n" + inputMailTextView.text!
        spinner.startAnimating()
        RequestGptService.uploadInfo(email: realBody) {
            doubleBody in
            DispatchQueue.main.async {
                self.spinner.stopAnimating()
                
                self.outputMailTextView.text = doubleBody
            }
        }
        
    }
    
    
    func autoGptButton(body: String){
        print("autoGpt")
        
        let realBody = "make this email formally\n\n" + body
        
        RequestGptService.uploadInfo(email: realBody) {
            doubleBody in
            DispatchQueue.main.async {
                self.spinner.stopAnimating()
            }
            print(realBody)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

}
