//
//  RequestEditProfile.swift
//  Rudder
//
//  Created by 박민호 on 2022/08/11.
//

import Foundation

struct RequestEditProfile {
    //login
    static func uploadInfo(profileBody: String, completion: @escaping (Int) -> Void) -> Void{
        let url = URL(string: Utils.springUrlKey+"/user-infos")!
    
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
      
        let editProfileRequest = EditProfileRequest(profileBody: profileBody)
        
        guard let EncodedUploadData = try? JSONEncoder().encode(editProfileRequest) else {
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


extension RequestEditProfile {
    struct EditProfileRequest: Codable {
        let profileBody: String
    }
}
