//
//  Request.swift
//  Rudder
//
//  Created by Brian Bae on 15/07/2021.
//

import UIKit


struct Request {
    
    private static var postsURL: URLComponents = URLComponents(string: "http://test.rudderuni.com/posts")!
    
    
    struct Response: Codable {
        let posts: [Post]
        
    }
}

extension Request {
    static func posts( categoryId: Int! , endPostId: Int, isMyPost: Bool, searchbody: String, completion: @escaping (_ posts: [Post]?) -> Void) {
        
        guard let token: String = UserDefaults.standard.string(forKey: "token"),
              token.isEmpty == false else {
            print("no token")
            return
        }
        
        postsURL.queryItems = []
        if categoryId != nil { postsURL.queryItems?.append(URLQueryItem(name: "categoryId", value: String(categoryId)))}
        if searchbody != "" { postsURL.queryItems?.append(URLQueryItem(name: "searchBody", value: searchbody))}
        if endPostId != -1 {postsURL.queryItems?.append(URLQueryItem(name: "endPostId", value: String(endPostId))) }
        if isMyPost == true { postsURL.queryItems?.append(URLQueryItem(name: "isMyPost", value: "true")) }
        
        var request = URLRequest(url: postsURL.url!)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.allHTTPHeaderFields = [ "Authorization" : "Bearer "+token ]
        
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
                let decodedResponse: Response = try decoder.decode(Response.self, from: data)
                DispatchQueue.main.async {
                    print(decodedResponse.posts.count)
                    completion(decodedResponse.posts)
                }
            } catch {
                print("응답 디코딩 실패 헀음 했음")
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
