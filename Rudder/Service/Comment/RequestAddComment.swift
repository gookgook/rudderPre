//
//  RequestAddComment.swift
//  Rudder
//
//  Created by Brian Bae on 24/08/2021.
//

import Foundation

struct RequestAddComment {
    //login
    static func uploadInfo(commentBody: String, groupNum: Int, postId: Int, status: String  ,completion: @escaping (Int) -> Void) -> Void{
        let url = URL(string: Utils.springUrlKey+"/comments")!
        
        guard let token: String = UserDefaults.standard.string(forKey: "token"),
              token.isEmpty == false else {
            print("no token")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.allHTTPHeaderFields = [ "Authorization" : "Bearer "+token ]
        
        let commentToAdd = CommentToAdd(postId: postId, commentBody: commentBody, status: status, groupNum: groupNum)
        
        guard let EncodedUploadData = try? JSONEncoder().encode(commentToAdd) else { return }
      
        let task = URLSession.shared.uploadTask(with: request, from: EncodedUploadData, completionHandler: { (data, response, error) in
            if let error = error {
                print ("error: \(error)")
                completion(-1)
                return
            }
            guard let response = response as? HTTPURLResponse,
                (200...299).contains(response.statusCode) else {
                print ("server error")
                completion(-1)
                return
            }
            
            completion(1)
        })
        task.resume()
    }
}

extension RequestAddComment {
    struct CommentToAdd: Codable {
        let postId: Int
        let commentBody: String //필요없음. 현재 api 명세 맞추기 위함
        let status: String
        let groupNum: Int
    }
}
