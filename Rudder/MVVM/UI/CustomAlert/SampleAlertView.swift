//
//  SampleAlertView.swift
//  Rudder
//
//  Created by 박민호 on 2022/07/13.
//

import UIKit

class SampleAlertView: UIView {
    let xibName = "SampleAlertView"
        
    @IBOutlet weak var rootView: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        Bundle.main.loadNibNamed(xibName, owner: self, options: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    @IBAction func confirm(_ sender: UIButton) {
        rootView.removeFromSuperview()
    }
}
