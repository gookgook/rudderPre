//
//  RequestUpdateCategory.swift
//  Rudder
//
//  Created by Brian Bae on 01/10/2021.
//

import Foundation

struct RequestUpdateCategory {
    //login
    static func uploadInfo(categoryIdList: [Int], completion: @escaping (Int) -> Void) -> Void{
        guard let token: String = UserDefaults.standard.string(forKey: "token"),
              token.isEmpty == false else {
            print("no token")
            return
        }
        let ucRequest = UcRequest(categories: categoryIdList)
        
        guard let EncodedUploadData = try? JSONEncoder().encode(ucRequest) else {return}
        let url = URL(string: Utils.springUrlKey+"/categories/user")!
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
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

struct UcRequest: Codable {
    let categories: [Int]
}
