//
//  RequestEditPost.swift
//  Rudder
//
//  Created by Brian Bae on 06/09/2021.
//

import Foundation
import SwiftUI


struct RequestEditPost {
    static func uploadInfo(postId:Int, postBody: String, completion: @escaping (Int) -> Void) -> Void{
        let url = URL(string: Utils.springUrlKey+"/posts/"+String(postId))!
        
        guard let token: String = UserDefaults.standard.string(forKey: "token"),
              token.isEmpty == false else {
            print("no token")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.allHTTPHeaderFields = [ "Authorization" : "Bearer "+token ]
        
        let postToEdit = PostToEdit(postBody: postBody)
        
        guard let EncodedUploadData = try? JSONEncoder().encode(postToEdit) else {
          return
        }
      
        let task = URLSession.shared.uploadTask(with: request, from: EncodedUploadData, completionHandler: { (data, response, error) in
            if let error = error {
                print ("error: \(error)")
                return
            }
                    
            guard let response = response as? HTTPURLResponse,
                (200...299).contains(response.statusCode) else {
                print ("server error")
                return
            }
            
            completion(1)
        })
        task.resume()
    }
}

extension RequestEditPost {
    struct PostToEdit: Codable {
        let postBody: String
    }
}
