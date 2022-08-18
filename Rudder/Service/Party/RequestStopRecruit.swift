//
//  RequestStopRecruit.swift
//  Rudder
//
//  Created by 박민호 on 2022/08/14.
//

import Foundation

struct RequestStopRecruit{
    static func uploadInfo(partyId: Int, completion: @escaping (Int) -> Void) -> Void{
        
        guard let token: String = UserDefaults.standard.string(forKey: "token"),
              token.isEmpty == false else {
            print("no token")
            return
        }
        
        let url = URL(string: Utils.springUrlKey+"/parties/"+String(partyId)+"/stop-recruit")!
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
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
            case 406: completion(2)
            default:
                print("server error")
                completion(-1)
            
            }
            
        })
        task.resume()
    }
}
