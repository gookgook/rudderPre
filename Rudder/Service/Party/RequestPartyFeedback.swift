//
//  RequestPartyFeedback.swift
//  Rudder
//
//  Created by 박민호 on 2022/08/25.
//

import Foundation

struct RequestPartyFeedback {
    //login
    static func uploadInfo(customerSoundBody: String, customerSoundType: String, partyId: Int, completion: @escaping (Int) -> Void) -> Void{
        let url = URL(string: Utils.springUrlKey+"/customer-sound")!
        
        guard let token: String = UserDefaults.standard.string(forKey: "token"),
              token.isEmpty == false else {
            print("no token")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.allHTTPHeaderFields = [ "Authorization" : "Bearer "+token ]
      
        let feedback = Feedback(customerSoundBody: customerSoundBody, customerSoundType: customerSoundType, partyId: partyId)
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

extension RequestPartyFeedback {
    struct Feedback: Codable {
        let customerSoundBody: String
        let customerSoundType: String
        let partyId: Int
    }
}
