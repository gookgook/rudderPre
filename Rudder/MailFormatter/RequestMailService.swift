//
//  RequestMailService.swift
//  Rudder
//
//  Created by 박민호 on 2022/12/21.
//

import Foundation



struct RequestMailService {
    //login
    static func uploadInfo(email: String, completion: @escaping (String) -> Void) -> Void{
                           

   
        let url = URL(string: "https://openapi.naver.com/v1/papago/n2mt")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded; charset=UTF-8", forHTTPHeaderField: "Content-Type")
        request.allHTTPHeaderFields = [
            "X-Naver-Client-Id" : "8jeHk0Dj1YevFPqSHLrM",
            "X-Naver-Client-Secret" : "mXvG5nkb5a"
        ]
        
        request.httpBody = ("source=ko&target=en&text="+email).data(using: .utf8)
        
      
        print("came came 1")
        let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
            
            print("came came")
            if let error = error {
                print ("error: \(error)")
                return
            }
            
            
            guard let response = response as? HTTPURLResponse,
                (200...299).contains(response.statusCode) else {
                
                print ("server error here")
                return
            }
            //lewandowski
            guard let data = data, error == nil else {
                print("server error")
                return
            }
            
            print("came here hre")
            let decoder:JSONDecoder = JSONDecoder()
            do {
                let decodedResponse: RMResponse = try decoder.decode(RMResponse.self, from: data)
                print("here service")

                completion(decodedResponse.message.result.translatedText)
                
               } catch let error as NSError {
                   completion("error")
                   print(error)
               }
        })
        task.resume()
    }
    
}

extension RequestMailService {
    struct RMBody: Codable {
        let translatedText: String
    }
    struct ResponseRM: Codable {
        let result: RMBody
    }
    struct RMResponse: Codable {
        let message: ResponseRM
    }
    
}
