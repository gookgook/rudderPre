//
//  LaunchViewController.swift
//  Rudder
//
//  Created by 박민호 on 2022/08/24.
//

import UIKit

final class LaunchViewController: UIViewController{
    var mainNavigationController = UINavigationController()
    var myNavigationController = UINavigationController()
    var myPreNavigationController = UINavigationController()
    var notificationController = UINavigationController()
    let myTabBarController = UITabBarController()
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
}

extension LaunchViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        spinner.startAnimating()
        
        myTabBarController.delegate = self
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let PartyMainVC = storyboard.instantiateViewController(identifier: "PartyMainViewController") as? PartyMainViewController else {
            print("Something wrong in storyboard")
            return
        }
        guard let LoginVC = storyboard.instantiateViewController(identifier: "StartViewController") as? StartViewController else {
            print("Something wrong in storyboard")
            return
        }
        
        guard let MyVC = storyboard.instantiateViewController(identifier: "MyApplicationsViewController") as? MyApplicationsViewController else {
            print("Something wrong in storyboard")
            return
        }
        
        guard let MyPreVC = storyboard.instantiateViewController(identifier: "MyPreViewController") as? MyPreViewController else {
            print("Something wrong in storyboard")
            return
        }
        
        /*guard let NotificationVC = storyboard.instantiateViewController(identifier: "NotificationViewController") as? NotificationViewController else {
            print("Something wrong in storyboard")
            return
        }*/
        
        if UserDefaults.standard.string(forKey: "token") != nil{
            print("token already exists")
            //navigationController = UINavigationController(rootViewController: LoginVC)
            Utils.firstScreen = 1 //아마 지워야함
            mainNavigationController.pushViewController(PartyMainVC, animated: true)
            mainNavigationController.viewControllers.insert(LoginVC, at: 0)
            
        }else{
            Utils.firstScreen = 0
            mainNavigationController = UINavigationController(rootViewController: LoginVC)
        }
        
        myNavigationController = UINavigationController(rootViewController: MyVC)
        myPreNavigationController = UINavigationController(rootViewController: MyPreVC)
       // notificationController = UINavigationController(rootViewController: NotificationVC)
        
        myTabBarController.tabBar.tintColor = MyColor.rudderPurple
        let mainTabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "house.fill"), tag: 0)
        let myPageTabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "checkmark.circle.fill"), tag: 1) //근데 이거 그냥 name 외부 이미지 해도 틴트가 된다??
        let messageTabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "crown.fill"), tag: 2)
        //let notificationTabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "bell"), tag: 3)
        //tag와 tab bar 순서 안맞는 사소한 문제
        mainNavigationController.tabBarItem = mainTabBarItem
        myNavigationController.tabBarItem = myPageTabBarItem
        myPreNavigationController.tabBarItem = messageTabBarItem
    //notificationController.tabBarItem = notificationTabBarItem
        
        
        let controllers = [mainNavigationController, myPreNavigationController,  myNavigationController/*,notificationController*/]
        myTabBarController.setViewControllers(controllers, animated: true)
        myTabBarController.modalPresentationStyle = .fullScreen
        
        RequestInitialDataGuest.uploadInfo() {status in
            DispatchQueue.main.async {
                switch status{
                case 1 :
                    self.present(self.myTabBarController, animated: false)
                case 2:
                    Alert.showAlert(title: "Please Update the app!", message: nil, viewController: self)
                default:
                    Alert.showAlert(title: "Server Error", message: nil, viewController: self)
                }
            }
        }
    }
}

extension LaunchViewController : UITabBarControllerDelegate {

    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        return viewController != tabBarController.selectedViewController
    }

    @objc func moveTab(notification: NSNotification){
        self.myTabBarController.selectedIndex = 3
    }

}
