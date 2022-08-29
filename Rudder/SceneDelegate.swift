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


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        
        
        guard let winScene = (scene as? UIWindowScene) else { return }
        //let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let LaunchVC = storyboard.instantiateViewController(identifier: "LaunchVC") as? LaunchViewController else {
            print("Something wrong in storyboard")
            return
        }
        
        window = UIWindow(windowScene: winScene)
        //window?.rootViewController = tabBarController
        window?.rootViewController = LaunchVC
        window?.makeKeyAndVisible()
        
        let k_moveToNotification = Notification.Name("moveToNotification") //이거이름재설정 필요
        //NotificationCenter.default.addObserver(self, selector: #selector(self.moveTab(notification:)), name: k_moveToNotification, object: nil)
        
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
