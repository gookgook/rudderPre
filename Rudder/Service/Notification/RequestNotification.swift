//
//  RequestNotification.swift
//  Rudder
//
//  Created by 박민호 on 2022/02/21.
//

import Foundation

struct ResponseNotification: Codable {
    let comments: [Comment]
    
    enum CodingKeys: String, CodingKey {
        case comments = "results"
    }
}

struct RequestNotification {
    
    private static let postsURL: URL = URL(string: Utils.springUrlKey+"/notifications")!
}

extension RequestNotification {
    static func notifications( completion: @escaping (_ notifications: [UserNotification]?) -> Void) {
        
        guard let token = UserDefaults.standard.string(forKey: "token") else {
            print("token failure")
            return
        }
        var request = URLRequest(url: postsURL)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.allHTTPHeaderFields = [ "Authorization" : "Bearer "+token ]
        
        //print(uploadData)
        let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
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
            
            let decoder:JSONDecoder = JSONDecoder()
            do {
                
                let decodedResponse: NResponse = try decoder.decode(NResponse.self, from: data)
                DispatchQueue.main.async {
                    completion(decodedResponse.notifications)
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

extension RequestNotification{
  
    
    struct NResponse: Codable {
        let notifications: [UserNotification]
    }
}
