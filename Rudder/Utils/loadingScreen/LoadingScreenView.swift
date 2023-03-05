//
//  LoadingScreenView.swift
//  Rudder
//
//  Created by 박민호 on 2022/12/02.
//

import UIKit

class LoadingScreenView: UIView {

    var timer:Timer?
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    //MARK: 초기화
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadXib()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadXib()
    }

    //MARK: Xib 로드
    private func loadXib(){
        
        //self 는 최상위 view - 보이지 않음
        self.tag = 100
        
        let identifier = String(describing: type(of: self))
        let nibs = Bundle.main.loadNibNamed(identifier, owner: self, options: nil)
        
        
        // 첫번째 Nib 중에서 첫번째 View
        guard let customView = nibs?.first as? UIView else {return}
        customView.frame = self.bounds
        customView.backgroundColor = UIColor(white: 1, alpha: 0.3)
        //customView.tag = 100
        self.addSubview(customView)
    }
    
    //MARK: 시작
    public func startLoading(){
        
        spinner.startAnimating()
    }
    
    
    //MARK: 정지
    public func stopLoading(){
        spinner.stopAnimating()
    }
    
    
}
