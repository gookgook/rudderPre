//
//  RequestPartyGroupChatRoom.swift
//  Rudder
//
//  Created by 박민호 on 2022/07/01.
//

import Foundation

struct RequestPartyGroupChatRoom {
    //login
    static func uploadInfo( partyId: Int ,completion: @escaping (ChatRoom?) -> Void) -> Void{ //학교 이름을 넘겨줄 수도 있어서
        let url = URL(string: (Utils.springUrlKey + "/chat-rooms/party-group/" + String(partyId)))!
        
        guard let token = UserDefaults.standard.string(forKey: "token") else {
            print("token failure")
            return
        }
   
        var request = URLRequest(url: url)
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
                    let decodedResponse: ChatRoom = try decoder.decode(ChatRoom.self, from: data)
                    completion(decodedResponse)
                } catch {
                    print("응답 디코딩 실패 MyPartyChatRoomm")
                    print(error.localizedDescription)
                    dump(error)
                    completion(nil)
                }
            default :
                print("Unknown Error MyPartyGroupChatRoom")
                completion(nil)
            }
            return
        })
        task.resume()
    }
}
