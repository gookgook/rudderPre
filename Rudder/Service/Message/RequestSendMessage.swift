//
//  RequestSendMessage.swift
//  Rudder
//
//  Created by 박민호 on 2022/02/08.
//

import Foundation

struct RequestSendMessage{
    private static let categoryURL: URL = URL(string: Utils.springUrlKey+"/post-messages")!
}

extension RequestSendMessage {
    static func uploadInfo( receiveUserInfoId: Int, messageBody: String, completion: @escaping  (Bool) -> Void) -> Void {
        
        guard let token: String = UserDefaults.standard.string(forKey: "token"),
              token.isEmpty == false else {
            print("no token")
            return
        }
        
        print("hit here send message")
        
        var request = URLRequest(url: categoryURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.allHTTPHeaderFields = [ "Authorization" : "Bearer "+token ]
        
        let uploadData = MessageToSend( receiveUserInfoId: receiveUserInfoId, messageBody: messageBody)
        guard let EncodedUploadData = try? JSONEncoder().encode(uploadData) else { return }

        let task = URLSession.shared.uploadTask(with: request, from: EncodedUploadData, completionHandler: { (data, response, error) in
            if let error = error {
                print ("error: \(error)")
                completion(false)
                return
            }
            guard let response = response as? HTTPURLResponse,
                (200...299).contains(response.statusCode) else {
                print ("server error")
                completion(false)
                return
            }
            print("send message success log")
            completion(true)
        })
        task.resume()
    }
}

struct MessageToSend: Codable {
    let receiveUserInfoId: Int
    let messageBody: String
}
