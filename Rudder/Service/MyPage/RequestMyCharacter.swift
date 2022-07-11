//
//  RequestMyCharacter.swift
//  Rudder
//
//  Created by Brian Bae on 11/09/2021.
//

import Foundation

struct RequestMyCharacter {
    //login
    static func uploadInfo( completion: @escaping (String) -> Void) -> Void{
                           
        let url = URL(string: (Utils.springUrlKey + "/user-profiles"))!
        
        guard let token: String = UserDefaults.standard.string(forKey: "token"),
              token.isEmpty == false else {
            print("no token")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.allHTTPHeaderFields = [ "Authorization" : "Bearer "+token ]
        
      
        let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
            if let error = error {
                print ("error: \(error)")
                completion("server error")
                return
            }
            guard let response = response as? HTTPURLResponse,
                (200...299).contains(response.statusCode) else {
                print ("server error")
                completion("server error")
                return
            }
            //lewandowski
            guard let data = data, error == nil else {
                print("server error")
                completion("server error")
                return
            }
            let decoder:JSONDecoder = JSONDecoder()
            do {
                let decodedResponse: ChResponse = try decoder.decode(ChResponse.self, from: data)
                
                completion(decodedResponse.profileImageUrl)
                
               } catch let error as NSError {
                   completion("server error")
                   print(error)
               }
        })
        task.resume()
    }
}

extension RequestMyCharacter {
    struct ChResponse: Codable {
        let profileBody: String
        let profileId: Int
        let profileImageId: Int
        let profileImageUrl: String
    }
}
