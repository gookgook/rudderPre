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
    
    
    private var swiftStomp: SwiftStomp!

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



//handling socket input
extension SceneDelegate: SwiftStompDelegate {
    func onConnect(swiftStomp: SwiftStomp, connectType: StompConnectType) {
            if connectType == .toSocketEndpoint{
                print("Connected to socket")
            } else if connectType == .toStomp{
                print("Connected to stomp")
                
                //** Subscribe to topics or queues just after connect to the stomp!
                swiftStomp.subscribe(to: "/queue/user.347") //userInfoId로 바꾸라
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
        /*let decoder:JSONDecoder = JSONDecoder()
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
        }*/
        let decoder: JSONDecoder = JSONDecoder()
        do {
            let myStruct = try decoder.decode(SocketMessage.self, from: message)
            switch myStruct.socketMessage {
            case .chat(let chat):
                print("is Chat "+String(chat.chatRoomId))
                let k_chatReceived = Notification.Name("chatReceived")
                let userInfo: [AnyHashable: Any] = ["receivedChat": chat]
                NotificationCenter.default.post(name: k_chatReceived, object: nil, userInfo: userInfo)
            case .notification(let notification):
                print("is Notification " + String(notification.notificationId))
            default:
                print("unsupported format")
            }
        }catch{
            print("dynamic decoding error")
        }
    }
}
