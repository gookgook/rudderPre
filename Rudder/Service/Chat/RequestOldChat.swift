//
//  RequestOldChat.swift
//  Rudder
//
//  Created by 박민호 on 2022/08/03.
//

import Foundation

struct RequestOldChat {
    static func uploadInfo( chatRoomId:Int, endChatMessageId:Int, completion: @escaping ([Chat]?) -> Void) -> Void{ //학교 이름을 넘겨줄 수도 있어서
        var url = URLComponents(string: (Utils.springUrlKey + "/chat-messages/" + String(chatRoomId)))!
        
        guard let token = UserDefaults.standard.string(forKey: "token") else {
            print("token failure")
            return
        }
        
        print("chatRoomId ", String(chatRoomId))

        
        if endChatMessageId != -1 { url.queryItems = [ URLQueryItem(name: "endChatMessageId", value: String(endChatMessageId)) ] }
        
        var request = URLRequest(url: url.url!)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.allHTTPHeaderFields = [ "Authorization" : "Bearer "+token ]
      
      
        let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
            if let error = error { print ("error: \(error)"); completion(nil); return }
            guard let response = response as? HTTPURLResponse else { print ("server error"); completion(nil); return }
            
            print("statuscode: ",String(response.statusCode))
            
            switch response.statusCode {
            case 200...299:
                let decoder:JSONDecoder = JSONDecoder()
                do {
                    guard let data = data else {
                        print("전달받은 데이터 없음")
                        completion(nil)
                        return
                    }
                    let decodedResponse: ChatResponse = try decoder.decode(ChatResponse.self, from: data)
                    completion(decodedResponse.chatMessages)
                } catch {
                    print("응답 디코딩 실패 Old Chats")
                    print(error.localizedDescription)
                    dump(error)
                    completion(nil)
                 }
            default :
                print("Unknown Error Old Chats")
                completion(nil)
            }
            return
        })
        task.resume()
    }
}

extension RequestOldChat {
    struct ChatResponse: Codable {
        let chatMessages: [Chat]
    }
}
