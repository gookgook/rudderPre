//
//  RequestAddLikeComment.swift
//  Rudder
//
//  Created by Brian Bae on 01/09/2021.
//

import Foundation


struct RequestAddLikeComment {
    static func uploadInfo(commentId: Int ,completion: @escaping (Int) -> Void) -> Void{
       
        let url = URL(string: Utils.springUrlKey+"/comments/"+String(commentId)+"/like")!
        
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
            
            completion(1)
        })
        task.resume()
    }
}

