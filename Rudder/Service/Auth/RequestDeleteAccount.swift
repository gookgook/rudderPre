//
//  RequestDeleteAccount.swift
//  Rudder
//
//  Created by 박민호 on 2022/11/21.
//

import Foundation

struct RequestDeleteAccount{
    static func uploadInfo(completion: @escaping (Int) -> Void) -> Void{
        
        guard let token: String = UserDefaults.standard.string(forKey: "token"),
              token.isEmpty == false else {
            print("no token")
            return
        }
        
        let url = URL(string: Utils.springUrlKey+"/user-infos/")!
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.allHTTPHeaderFields = [ "Authorization" : "Bearer "+token ]
      
        let task = URLSession.shared.dataTask(with: request,  completionHandler: { (data, response, error) in
            if let error = error {
                print ("error: \(error)")
                completion(-1)
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                print ("server error")
                completion(-1)
                return
            }
            
            switch response.statusCode{
            case 204: completion(1)
            default:
                print("server error")
                completion(-1)
            
            }
            
        })
        task.resume()
    }
}
