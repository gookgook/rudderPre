//
//  SceneDelegate.swift
//  Rudder
//
//  Created by Brian Bae on 13/07/2021.
//

import UIKit
import FirebaseDynamicLinks

class SceneDelegate: UIResponder, UIWindowSceneDelegate{

    var window: UIWindow?
    
    var navigationController = UINavigationController()
    var myNavigationController = UINavigationController()
    var messageNavigationController = UINavigationController()
    var notificationController = UINavigationController()
    let tabBarController = UITabBarController()

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        tabBarController.delegate = self
        
        
        
        guard let winScene = (scene as? UIWindowScene) else { return }
        //let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let TmpVC = storyboard.instantiateViewController(identifier: "TmpViewController") as? TmpViewController else {
            print("Something wrong in storyboard")
            return
        }
        guard let LoginVC = storyboard.instantiateViewController(identifier: "LoViewController") as? LoginViewController else {
            print("Something wrong in storyboard")
            return
        }
        
        guard let MyVC = storyboard.instantiateViewController(identifier: "MyPageViewController") as? MyPageViewController else {
            print("Something wrong in storyboard")
            return
        }
        
        guard let MessageVC = storyboard.instantiateViewController(identifier: "MessageViewController") as? MessageRoomViewController else {
            print("Something wrong in storyboard")
            return
        }
        
        guard let NotificationVC = storyboard.instantiateViewController(identifier: "NotificationViewController") as? NotificationViewController else {
            print("Something wrong in storyboard")
            return
        }
        
        if UserDefaults.standard.string(forKey: "token") != nil{
            print("token already exists")
            //navigationController = UINavigationController(rootViewController: LoginVC)
            Utils.firstScreen = 1
            navigationController.pushViewController(TmpVC, animated: true)
            navigationController.viewControllers.insert(LoginVC, at: 0)
            
        }else{
            Utils.firstScreen = 0
            navigationController = UINavigationController(rootViewController: LoginVC)
        }
        
        myNavigationController = UINavigationController(rootViewController: MyVC)
        messageNavigationController = UINavigationController(rootViewController: MessageVC)
        notificationController = UINavigationController(rootViewController: NotificationVC)
        
        tabBarController.tabBar.tintColor = MyColor.rudderPurple
        let naviTabBarItem = UITabBarItem(title: nil, image: UIImage(named: "board"), tag: 0)
        let myPageTabBarItem = UITabBarItem(title: nil, image: UIImage(named: "myPage"), tag: 1)
        let messageTabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "envelope"), tag: 2)
        let notificationTabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "bell"), tag: 3)
        //tag와 tab bar 순서 안맞는 사소한 문제
        navigationController.tabBarItem = naviTabBarItem
        myNavigationController.tabBarItem = myPageTabBarItem
        messageNavigationController.tabBarItem = messageTabBarItem
        notificationController.tabBarItem = notificationTabBarItem
        
        
        let controllers = [navigationController, messageNavigationController,  myNavigationController,notificationController]
        tabBarController.setViewControllers(controllers, animated: true)
        //tabBarController.tabBar.selectedImageTintColor = UIColor(red: 147/255, green: 41/255, blue: 209/255, alpha: 1)
        window = UIWindow(windowScene: winScene)
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
        
        let k_moveToNotification = Notification.Name("moveToNotification") //이거이름재설정 필요
        NotificationCenter.default.addObserver(self, selector: #selector(self.moveTab(notification:)), name: k_moveToNotification, object: nil)
        
        //let k_moveToNotification = Notification.N name("moveToNotification")
    }
    
    
}

//handling dynamic link
extension SceneDelegate {
    func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {
        print("touch dynamic link")
        if let incomingURL = userActivity.webpageURL {
            let linkHandled = DynamicLinks.dynamicLinks().handleUniversalLink(incomingURL)
                { (dynamicLink, error) in
                guard error == nil else {
                    print("FB DL parse error! \(error!.localizedDescription)")
                    return
                }
                if let dynamicLink = dynamicLink {
                    self.handleIncomingDynamicLink(dynamicLink)
                }
            }
            
        }
    }
    
    func handleIncomingDynamicLink(_ dynamicLink: DynamicLink){
        print("touch handle dynamic link")
        guard let url = dynamicLink.url else {
            print("dynamic link object has no url")
            return
        }
        print("Your incoming link parameter is \(url.absoluteString)")
    }
}
//tab bar double tap 방지
extension SceneDelegate: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        return viewController != tabBarController.selectedViewController
    }
    
    @objc func moveTab(notification: NSNotification){
        self.tabBarController.selectedIndex = 3
    }
}
