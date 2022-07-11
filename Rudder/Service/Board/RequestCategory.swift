//
//  RequestCategory.swift
//  Rudder
//
//  Created by Brian Bae on 23/08/2021.
//

import Foundation




struct RequestCategory {
    private static var categoryURL: URLComponents = URLComponents(string: Utils.springUrlKey+"/categories")!
    
    struct ResponseCategory: Codable {
        let categories: [Category]
    }
    
}

extension RequestCategory {
    static func categories( categoryTypes: [String]!, isUserSelectCategory: Bool,  completion: @escaping (_ categories: [Category]?) -> Void) {
        
        guard let token: String = UserDefaults.standard.string(forKey: "token"),
              token.isEmpty == false else {
            print("no token")
            return
        }
        
        categoryURL.queryItems = []
        
        if categoryTypes != nil { categoryURL.queryItems?.append(URLQueryItem(name: "categoryTypes", value: Utils.arrayToString(data: categoryTypes) )) }
        categoryURL.queryItems?.append(URLQueryItem(name: "isUserSelectCategory", value: String(isUserSelectCategory)))
        /*if searchbody != "" { postsURL.queryItems?.append(URLQueryItem(name: "searchBody", value: searchbody))}
        if endPostId != -1 {postsURL.queryItems?.append(URLQueryItem(name: "endPostId", value: String(endPostId))) }*/
        
        var request = URLRequest(url: categoryURL.url!)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.allHTTPHeaderFields = [
            "Authorization" : "Bearer "+token
        ]
        
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
                
                let decodedResponse: ResponseCategory = try decoder.decode(ResponseCategory.self, from: data)
                DispatchQueue.main.async {
                    completion(decodedResponse.categories)
                }
            } catch {
                print("응답 디코딩 실패 category")
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

