//
//  RequestAddCategory.swift
//  Rudder
//
//  Created by 박민호 on 2022/03/08.
//

import Foundation


struct RequestAddCategory {
    //login
    static func uploadInfo(categoryName: String, completion: @escaping (Int) -> Void) -> Void{
        guard let token: String = UserDefaults.standard.string(forKey: "token"),
              token.isEmpty == false else {
            print("no token")
            return
        }
        let ucRequest = ACRequest(categoryName: categoryName)
        
        guard let EncodedUploadData = try? JSONEncoder().encode(ucRequest) else {return}
        let url = URL(string: Utils.urlKey+"/board/requestAddCategory")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
      
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

extension RequestAddCategory {
    struct ACRequest: Codable {
        let categoryName: String
    }
}

