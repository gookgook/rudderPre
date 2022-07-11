//
//  RequestSinglePost.swift
//  Rudder
//
//  Created by 박민호 on 2022/03/01.
//

import Foundation


struct RequestSinglePost {
    static func singlePost(postId: Int ,completion: @escaping (_ post: Post?) -> Void) {
        
        let singlePostURL: URLComponents = URLComponents(string: Utils.springUrlKey+"/posts/"+String(postId))!
        
        guard let token: String = UserDefaults.standard.string(forKey: "token"),
              token.isEmpty == false else {
            print("no token")
            return
        }
        
        var request = URLRequest(url: singlePostURL.url!)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.allHTTPHeaderFields = ["Authorization" : "Bearer "+token]
      
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
                
                let decodedResponse: SPResponse = try decoder.decode(SPResponse.self, from: data)
                DispatchQueue.main.async {
                    completion(decodedResponse.post)
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

extension RequestSinglePost {
    struct SPResponse: Codable {
        let post: Post
    }
}

