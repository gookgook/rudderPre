//
//  RequestMyComment.swift
//  Rudder
//
//  Created by 박민호 on 2022/05/24.
//

import Foundation

struct RequestMyComment {
    private static var postsURL: URLComponents = URLComponents(string: Utils.springUrlKey + "/posts/my-comment")!
}

extension RequestMyComment {
    static func posts( endPostId: Int, completion: @escaping (_ posts: [Post]?) -> Void) {
        
        guard let token: String = UserDefaults.standard.string(forKey: "token"),
              token.isEmpty == false else {
            print("no token")
            return
        }
   
        var request = URLRequest(url: postsURL.url!)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.allHTTPHeaderFields = [ "Authorization" : "Bearer "+token ]
        
        postsURL.queryItems = []
        
        if endPostId != -1 {postsURL.queryItems?.append(URLQueryItem(name: "endPostId", value: String(endPostId))) }
      
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
            
            
            //isSuccess false도 처리
            let decoder:JSONDecoder = JSONDecoder()
            do {
                let decodedResponse: MyPostResponse = try decoder.decode(MyPostResponse.self, from: data)
                print("post",decodedResponse.posts.count)
                DispatchQueue.main.async {
                    completion(decodedResponse.posts)
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

extension RequestMyComment{
    
    struct MyPostResponse: Codable {
        let posts: [Post]
    }
}
