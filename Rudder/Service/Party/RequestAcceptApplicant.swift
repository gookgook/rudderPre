//
//  RequestAcceptApplicant.swift
//  Rudder
//
//  Created by 박민호 on 2022/08/08.
//
import Foundation

struct RequestAcceptApplicant {
    static func uploadInfo(partyId: Int, partyMemberId: Int,completion: @escaping (Int) -> Void) -> Void{
        
        guard let token: String = UserDefaults.standard.string(forKey: "token"),
              token.isEmpty == false else {
            print("no token")
            return
        }
        
        let arRequest = ApproveRequest(partyMemberId: partyMemberId)
        
        guard let EncodedUploadData = try? JSONEncoder().encode(arRequest) else {
          return
        }
        
        let url = URL(string: Utils.springUrlKey+"/"+String(partyId)+"/approve")!
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.allHTTPHeaderFields = [ "Authorization" : "Bearer "+token ]
      
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
extension RequestAcceptApplicant {

    struct ApproveRequest: Codable {
        let partyMemberId: Int
    }
 }
