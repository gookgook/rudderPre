//
//  RequestAddLike.swift
//  Rudder
//
//  Created by Brian Bae on 26/08/2021.
//

import Foundation

struct LikeResponse: Codable {
    let likeCount: Int
}


struct RequestAddLike {
    static func uploadInfo(postId: Int, completion: @escaping (Int) -> Void) -> Void{
        
        let url = URL(string: Utils.springUrlKey+"/posts/"+String(postId)+"/like-count")!
        
        guard let token: String = UserDefaults.standard.string(forKey: "token"),
              token.isEmpty == false else {
            print("no token")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
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
                completion(-1)
                return
            }
            
            guard let data = data, error == nil else {
                print("server error")
                completion(-1)
                return
            }
            
            let decoder:JSONDecoder = JSONDecoder()
            do {
                
                let decodedResponse: LikeResponse = try decoder.decode(LikeResponse.self, from: data)
                DispatchQueue.main.async {
                    completion(decodedResponse.likeCount)
                }
            } catch {
                print("응답 디코딩 실패")
                print(error.localizedDescription)
                dump(error)
                DispatchQueue.main.async {
                    completion(-1)
                }
            }
            
            completion(1)
        })
        task.resume()
    }
}
