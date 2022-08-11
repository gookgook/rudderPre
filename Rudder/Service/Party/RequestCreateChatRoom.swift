//
//  RequestCreateChatRoom.swift
//  Rudder
//
//  Created by 박민호 on 2022/08/10.
//

import Foundation

struct RequestCreateChatRoom {
    static func uploadInfo(partyId: Int, userInfoIdList: [Int], completion: @escaping (Int?) -> Void) -> Void{
        let url = URL(string: Utils.springUrlKey+"/chat-rooms")!
        
        guard let token: String = UserDefaults.standard.string(forKey: "token"),
              token.isEmpty == false else {
            print("no token")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.allHTTPHeaderFields = [ "Authorization" : "Bearer "+token ]
        
        let ccRequest = CCRequest(chatRoomItemId: partyId, chatRoomType: "PARTY_ONE_TO_ONE", userInfoIdList: userInfoIdList)
        
        guard let EncodedUploadData = try? JSONEncoder().encode(ccRequest) else {
            return
        }
      
        let task = URLSession.shared.uploadTask(with: request, from: EncodedUploadData, completionHandler: { (data, response, error) in
            if let error = error {
                print ("error: \(error)")
                completion(nil)
                return
            }
            guard let response = response as? HTTPURLResponse,
                (200...299).contains(response.statusCode) else {
                print ("server error")
                completion(nil)
                return
            }
            let decoder:JSONDecoder = JSONDecoder()
            do {
                guard let data = data else {
                    print("전달받은 데이터 없음")
                    completion(nil)
                    return
                }
                let decodedResponse: CCResponse = try decoder.decode(CCResponse.self, from: data)
                completion(decodedResponse.chatRoomId)
            } catch {
                print("응답 디코딩 실패 MyPartyDates")
                print(error.localizedDescription)
                dump(error)
                completion(nil)
            }
      
            
        })
        task.resume()
    }
}

extension RequestCreateChatRoom {
    struct CCRequest: Codable {
        let chatRoomItemId: Int
        let chatRoomType: String
        let userInfoIdList: [Int]
    }
    struct CCResponse: Codable {
        let chatRoomId: Int
    }
}
