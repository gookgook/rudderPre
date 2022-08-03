//
//  SceneDelegate.swift
//  Rudder
//
//  Created by Brian Bae on 13/07/2021.
//

import UIKit
import FirebaseDynamicLinks
import SwiftStomp

class SceneDelegate: UIResponder, UIWindowSceneDelegate{

    var window: UIWindow?
    
    var mainNavigationController = UINavigationController()
    var myNavigationController = UINavigationController()
    var myPreNavigationController = UINavigationController()
    var notificationController = UINavigationController()
    let tabBarController = UITabBarController()
    
    private var swiftStomp: SwiftStomp!

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        tabBarController.delegate = self
        
        
        
        guard let winScene = (scene as? UIWindowScene) else { return }
        //let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let PartyMainVC = storyboard.instantiateViewController(identifier: "PartyMainViewController") as? PartyMainViewController else {
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
            Utils.firstScreen = 1
            mainNavigationController.pushViewController(PartyMainVC, animated: true)
            mainNavigationController.viewControllers.insert(LoginVC, at: 0)
            
        }else{
            Utils.firstScreen = 0
            mainNavigationController = UINavigationController(rootViewController: LoginVC)
        }
        
        myNavigationController = UINavigationController(rootViewController: MyVC)
        myPreNavigationController = UINavigationController(rootViewController: MyPreVC)
       // notificationController = UINavigationController(rootViewController: NotificationVC)
        
        tabBarController.tabBar.tintColor = MyColor.rudderPurple
        let mainTabBarItem = UITabBarItem(title: nil, image: UIImage(named: "board"), tag: 0)
        let myPageTabBarItem = UITabBarItem(title: nil, image: UIImage(named: "myPage"), tag: 1)
        let messageTabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "envelope"), tag: 2)
        //let notificationTabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "bell"), tag: 3)
        //tag와 tab bar 순서 안맞는 사소한 문제
        mainNavigationController.tabBarItem = mainTabBarItem
        myNavigationController.tabBarItem = myPageTabBarItem
        myPreNavigationController.tabBarItem = messageTabBarItem
    //notificationController.tabBarItem = notificationTabBarItem
        
        
        let controllers = [mainNavigationController, myPreNavigationController,  myNavigationController/*,notificationController*/]
        tabBarController.setViewControllers(controllers, animated: true)
        //tabBarController.tabBar.selectedImageTintColor = UIColor(red: 147/255, green: 41/255, blue: 209/255, alpha: 1)
        window = UIWindow(windowScene: winScene)
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
        
        let k_moveToNotification = Notification.Name("moveToNotification") //이거이름재설정 필요
        NotificationCenter.default.addObserver(self, selector: #selector(self.moveTab(notification:)), name: k_moveToNotification, object: nil)
        
        
        initStomp()
        triggerConnect()
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


//handling socket input
extension SceneDelegate: SwiftStompDelegate {
    func onConnect(swiftStomp: SwiftStomp, connectType: StompConnectType) {
            if connectType == .toSocketEndpoint{
                print("Connected to socket")
            } else if connectType == .toStomp{
                print("Connected to stomp")
                
                //** Subscribe to topics or queues just after connect to the stomp!
                swiftStomp.subscribe(to: "/queue/user.218")
                //swiftStomp.subscribe(to: "/topic/greeting2")
                
            }
        }
        
        func onDisconnect(swiftStomp: SwiftStomp, disconnectType: StompDisconnectType) {
            if disconnectType == .fromSocket{
                print("Socket disconnected. Disconnect completed")
            } else if disconnectType == .fromStomp{
                print("Client disconnected from stomp but socket is still connected!")
            }
        }
        
        func onMessageReceived(swiftStomp: SwiftStomp, message: Any?, messageId: String, destination: String, headers : [String : String]) {
            
            print("message Received")
            
            if let message = message as? Data {
                print("as DATA")
                //handleMessage(message: message)
            }else if let message = message as? String{
                let dMessage = message.data(using: .utf8)!
                print(message)
                /*Alert.showAlert(title: message, message: nil, viewController: self.window!.rootViewController!)*/
                handleMessage(message: dMessage)
                print("as STRING")
            }
            
            print()
        }
        
        func onReceipt(swiftStomp: SwiftStomp, receiptId: String) {
            print("Receipt with id `\(receiptId)` received")
        }
        
        func onError(swiftStomp: SwiftStomp, briefDescription: String, fullDescription: String?, receiptId: String?, type: StompErrorType) {
            if type == .fromSocket{
                print("Socket error occurred! [\(briefDescription)]")
            } else if type == .fromStomp{
                print("Stomp error occurred! [\(briefDescription)] : \(String(describing: fullDescription))")
            } else {
                print("Unknown error occured!")
            }
        }
        
        func onSocketEvent(eventName: String, description: String) {
            print("Socket event occured: \(eventName) => \(description)")
        }
    
    private func initStomp(){
    
        let url = URL(string: "ws://test.rudderuni.com/ws")!
        
        self.swiftStomp = SwiftStomp(host: url)
        self.swiftStomp.enableLogging = true
        self.swiftStomp.delegate = self
        self.swiftStomp.autoReconnect = true
                
        self.swiftStomp.enableAutoPing()
    }
    
    @objc func appDidBecomeActive(notification : Notification){
        if !self.swiftStomp.isConnected{
            self.swiftStomp.connect()
        }
    }
    
    @objc func appWillResignActive(notication : Notification){
        if self.swiftStomp.isConnected{
            self.swiftStomp.disconnect(force: true)
        }
    }
    
    func triggerConnect() {
        if !self.swiftStomp.isConnected{
            self.swiftStomp.connect()
        }
        
    }
        
    func triggerDisconnect(_ sender: Any) {
        if self.swiftStomp.isConnected{
            self.swiftStomp.disconnect()
        }
    }
}


extension SceneDelegate {
    func handleMessage(message: Data) {
        let decoder:JSONDecoder = JSONDecoder()
        do {
            
            //let decodedResponse: Chat = try decoder.decode(Chat.self, from: message)
            let decodedResponse: SocketMessage = try decoder.decode(SocketMessage.self, from: message)
            let k_chatReceived = Notification.Name("chatReceived")
            let userInfo: [AnyHashable: Any] = ["receivedChat":decodedResponse.payload]
            NotificationCenter.default.post(name: k_chatReceived, object: nil, userInfo: userInfo)
        } catch {
            print("응답 디코딩 실패")
            print(error.localizedDescription)
            dump(error)
            DispatchQueue.main.async {
               // completion(-1)
            }
        }
    }
}
