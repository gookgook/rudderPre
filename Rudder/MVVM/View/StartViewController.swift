//
//  StartViewController.swift
//  Rudder
//
//  Created by 박민호 on 2022/08/17.
//

import UIKit

final class StartViewController: UIViewController {
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    @IBOutlet weak var signUpButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUIs()
    }
    
    @IBAction func touchUpSignUpButton(_ sender: UIButton) {
        self.performSegue(withIdentifier: "GoSignUp", sender: sender)
    }
    
    @IBAction func touchUpLoginButton(_ sender: UIButton) {
        self.performSegue(withIdentifier: "GoLogin", sender: sender)
    }
}

extension StartViewController {
    func setUIs(){
        self.tabBarController?.tabBar.isHidden = true
        signUpButton.applyGradient(colors: MyColor.gPurple)
    }
}
