//
//  StompManager.swift
//  Rudder
//
//  Created by 박민호 on 2022/08/27.
//

import Foundation
import SwiftStomp

class StompManager: SwiftStompDelegate{
    private var swiftStomp: SwiftStomp!
    
    static let shared = StompManager()
    
}

extension StompManager {
    func onConnect(swiftStomp: SwiftStomp, connectType: StompConnectType) {
            if connectType == .toSocketEndpoint{
                print("Connected to socket")
            } else if connectType == .toStomp{
                print("Connected to stomp")
                
                //** Subscribe to topics or queues just after connect to the stomp!
                let myUserInfoId = UserDefaults.standard.integer(forKey: "userInfoId")
                //swiftStomp.subscribe(to: "/queue/user.347") //userInfoId로 바꾸라
                swiftStomp.subscribe(to: "/queue/user." + String(myUserInfoId))
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
    
    func initStomp(){
    
        let url = URL(string: "ws://api.rudderuni.com/ws")!
        
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


extension StompManager {
    func handleMessage(message: Data) {
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
                handleNotification(notification: notification)
            default:
                print("unsupported notification format")
            }
        }catch{
            print("dynamic decoding error")
        }
    }
}

extension StompManager {
    func handleNotification(notification: UserNotification){
        switch notification.notificationType {
        case "PARTY_APPLY" :
            let k_newApplication = Notification.Name("newApplication")
            NotificationCenter.default.post(name: k_newApplication, object: nil, userInfo: nil)
        case "PARTY_ACCEPTED":
            let k_accepted = Notification.Name("accepted")
            NotificationCenter.default.post(name: k_accepted, object: nil, userInfo: nil)
        default :
            print("unknown notification")
        }
    }
}
