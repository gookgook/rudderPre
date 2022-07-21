//
//  Chat.swift
//  Rudder
//
//  Created by 박민호 on 2022/06/20.
//

import Foundation

struct Chat: Codable {
    let chatMessageId: Int
    let chatMessageBody: String
    let chatMessageTime: String
    let sendUserInfoId: Int
    let sendUserNickname: String
    let isMine: Bool
    let chatRoomId: Int
}


struct RequestSendChat {
    //login
    static func uploadInfo(channelId: Int, chatBody:String, completion: @escaping (Int) -> Void) -> Void{
        let url = URL(string: "http://test.rudderuni.com"+"/send-chat")!
        
        guard let token: String = UserDefaults.standard.string(forKey: "token"),
              token.isEmpty == false else {
            print("no token")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.allHTTPHeaderFields = [ "Authorization" : "Bearer "+token ]
        
        let chatToSend = ChatToSend(sender: "mock", body: chatBody, channelId: channelId, sendTime: nil)

        guard let EncodedUploadData = try? JSONEncoder().encode(chatToSend) else {
            return
        }
      
        let task = URLSession.shared.uploadTask(with: request, from: EncodedUploadData, completionHandler: { (data, response, error) in
            if let error = error {
                print ("error: \(error)")
                completion(-1)
                return
            }
            guard let response = response as? HTTPURLResponse,
                (200...299).contains(response.statusCode) else {
                print ("server error")
                completion(-1)
                return
            }
            
            completion(1)
            
            
        })
        task.resume()
    }
}

extension RequestSendChat {
    struct AddPostResponse: Codable {
        let postId: Int
    }
    
    struct ChatToSend: Codable {
        let sender: String
        let body: String
        let channelId: Int
        let sendTime: Int!
    }
}
