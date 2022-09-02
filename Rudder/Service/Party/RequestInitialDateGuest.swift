//
//  RequestInitialDateGuest.swift
//  Rudder
//
//  Created by 박민호 on 2022/09/01.
//

import Foundation

struct RequestInitialDataGuest {
    static func uploadInfo( completion: @escaping (Int) -> Void) -> Void{
        
        guard let dictionary = Bundle.main.infoDictionary,
              let version = dictionary["CFBundleShortVersionString"] as? String else {
            print("app version error")
            return
        }
        
        var url = URLComponents(string: Utils.springUrlKey+"/initial-data/guest")!
        
        url.queryItems = [ URLQueryItem(name: "appVersion", value: version),
        URLQueryItem(name: "os", value: "ios")]
    
        var request = URLRequest(url: url.url!)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
       
      
        let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
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
            do {
                let decoder:JSONDecoder = JSONDecoder()
                guard let data = data else {
                    print("전달받은 데이터 없음")
                    completion(-1)
                    return
                }
                let decodedResponse: ResponseData = try decoder.decode(ResponseData.self, from: data)
                if decodedResponse.results.isNewest {
                    completion(1)
                    return
                }
                else {
                    completion(2)
                    return
                }
            } catch {
                print("응답 디코딩 실패 initialdata guest")
                completion(-1)
                return
            }
            
        })
        task.resume()
    }
}


extension RequestInitialDataGuest {
 
    struct DataResponse : Codable {
        let isNewest: Bool
    }
    struct ResponseData: Codable {
        let results : DataResponse
    }
}
