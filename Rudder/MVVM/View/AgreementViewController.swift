//
//  AgreementViewController.swift
//  Rudder
//
//  Created by Brian Bae on 10/09/2021.
//

import UIKit
import WebKit

final class AgreementViewController: UIViewController {
    
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setBar()
        webView.navigationDelegate = self
        
        guard let url = URL(string: "https://sites.google.com/view/rudderuseragreement") else {
            return
        }
        
        webView.load(URLRequest(url: url))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        setBarStyle()
    }
    
}

extension AgreementViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        spinner.startAnimating()
        print("load start")
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        spinner.stopAnimating()
        print("load finish")
    }
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        spinner.stopAnimating()
        print("server error")
    }
}

extension AgreementViewController {
    func setBar(){
        self.navigationItem.hidesBackButton = true
        let label = UILabel()
        label.text = " Terms & Conditions"
        label.textAlignment = .left
        label.font = UIFont(name: "SF Pro Text Bold", size: 20)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: label)
        
        let backButtonView = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 40, height: 40)))
        let backButton = UIButton(type: .system)
        backButton.frame = CGRect(origin: .zero, size: CGSize(width: 40, height: 40))
        backButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        backButton.addTarget(self, action: #selector(goBack(_:)), for: .touchUpInside)
        backButtonView.addSubview(backButton)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: backButtonView)
        
    }
    
    func setBarStyle(){
        self.navigationController?.navigationBar.tintColor = .black
        self.navigationController?.navigationBar.barTintColor = .white
        //self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for:.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.layoutIfNeeded()
    }
    
    @objc func goBack(_ sender: UIBarButtonItem){
        print("go Back touched")
        self.navigationController?.popViewController(animated: true)
        //dismiss(animated: true, completion: nil)
    }
}
