//
//  RequestGptService.swift
//  Rudder
//
//  Created by 박민호 on 2023/02/01.
//

import Foundation



struct RequestGptService {
    //login
    static func uploadInfo(email: String, completion: @escaping (String) -> Void) -> Void{
                           

   
        let url = URL(string: "https://api.openai.com/v1/completions")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.allHTTPHeaderFields = [
            "Authorization" : "Bearer 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"
        ]
        //request.httpBody = "source=ko&target=en&text=만나서 반갑습니다.".data(using: .utf8)
        
      
        let gptRequest = GptRequest(model: "text-davinci-003", prompt: email, temperature: 0, max_tokens: 100)
        
        guard let EncodedUploadData = try? JSONEncoder().encode(gptRequest) else {
            return
        }
      
      
        print("came came 1")
        let task = URLSession.shared.uploadTask(with: request, from: EncodedUploadData, completionHandler: { (data, response, error) in
            
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
                let decodedResponse: GptResponse = try decoder.decode(GptResponse.self, from: data)
                print("here service")

                completion(decodedResponse.choices[0].text)
                
               } catch let error as NSError {
                   completion("error")
                   print(error)
               }
        })
        task.resume()
    }
    
}

extension RequestGptService {
    struct ResponseGPT: Codable {
        let text: String
    }
    struct GptResponse: Codable {
        let choices: [ResponseGPT]
    }
    
    struct GptRequest: Codable {
        let model: String
        let prompt: String
        let temperature: Int
        let max_tokens: Int
    }
}
