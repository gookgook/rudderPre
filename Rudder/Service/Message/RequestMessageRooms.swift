//
//  RequestMessageRooms.swift
//  Rudder
//
//  Created by 박민호 on 2022/01/24.
//

import Foundation

struct ResponseMessageRoom: Codable {
    
    let postMessageRooms: [MessageRoom]
}

struct RequestMessageRooms {
    private static let categoryURL: URL = URL(string: Utils.springUrlKey+"/post-messages/rooms")!
}

extension RequestMessageRooms {
    static func messageRooms( completion: @escaping (_ messageRooms: [MessageRoom]?) -> Void) {
        
        guard let token: String = UserDefaults.standard.string(forKey: "token"),
              token.isEmpty == false else {
            print("no token")
            return
        }
        
        var request = URLRequest(url: categoryURL)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.allHTTPHeaderFields = [ "Authorization" : "Bearer "+token ]
        
        let task = URLSession.shared.dataTask(with: request,  completionHandler: { (data, response, error) in
            if let error = error {
                print ("error: \(error)")
                return
            }
            guard let response = response as? HTTPURLResponse,
                (200...299).contains(response.statusCode) else {
                print ("server error")
                
                return
            }
            guard let data = data else {
                print("전달받은 데이터 없음")
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }
            
          //isSuccess false 인거도 처리
            let decoder:JSONDecoder = JSONDecoder()
            do {
                
                let decodedResponse: ResponseMessageRoom = try decoder.decode(ResponseMessageRoom.self, from: data)
                DispatchQueue.main.async {
                    completion(decodedResponse.postMessageRooms)
                }
            } catch {
                print("응답 디코딩 실패")
                print(error.localizedDescription)
                dump(error)
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        })
        task.resume()
    }
}
