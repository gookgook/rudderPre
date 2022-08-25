//
//  RequestFeedback.swift
//  Rudder
//
//  Created by Brian Bae on 12/09/2021.
//

import Foundation

struct RequestFeedback {
    //login
    static func uploadInfo(feedbackBody: String, completion: @escaping (Int) -> Void) -> Void{
        let url = URL(string: Utils.springUrlKey+"/user-requests")!
        
        guard let token: String = UserDefaults.standard.string(forKey: "token"),
              token.isEmpty == false else {
            print("no token")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.allHTTPHeaderFields = [ "Authorization" : "Bearer "+token ]
      
        let feedback = Feedback(body: feedbackBody)
        guard let EncodedUploadData = try? JSONEncoder().encode(feedback) else {
            return
        }
        
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

extension RequestFeedback {
    struct Feedback: Codable {
        let body: String
    }
}
