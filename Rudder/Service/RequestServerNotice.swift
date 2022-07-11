//
//  RequestServerNotice.swift
//  Rudder
//
//  Created by Brian Bae on 12/09/2021.
//

import Foundation

struct GetNotice: Codable {
    let results: TmpGetNotice
}
struct TmpGetNotice: Codable {
    let isExist: Bool
    let notice: String

}

struct RequestServerNotice {
    //login
    static func uploadInfo( completion: @escaping (String?) -> Void) -> Void{ // completion optional!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
        var url : URLComponents = URLComponents(string: "http://test.rudderuni.com/notice")!
        var request = URLRequest(url: url.url!)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let dictionary = Bundle.main.infoDictionary
        guard dictionary != nil else {return}
        guard let version = dictionary!["CFBundleShortVersionString"] as? String else {return}
        
        url.queryItems = [
            URLQueryItem(name: "os", value: "ios"),
            URLQueryItem(name: "version", value: version)
        ]
      
      
        let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
            if let error = error {
                print ("error: \(error)")
                completion(nil) //이번에 추가한거
                return
            }
            guard let response = response as? HTTPURLResponse,
                (200...299).contains(response.statusCode) else {
                print ("server error")
                completion(nil) //이번에 추가한거
                return
            }
            
            guard let data = data else {
                print("전달받은 데이터 없음")
                DispatchQueue.main.async {
                    completion(nil)  //error handle !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
                }
                return
            }
            
            let decoder:JSONDecoder = JSONDecoder()
            do {
                let TResponse: GetNotice = try decoder.decode(GetNotice.self, from: data)
                //let decodedResponse: Response = try decoder.decode(Response.self, from: data)
                if TResponse.results.isExist == true { completion(TResponse.results.notice) }
                else  {completion(nil) }
            } catch {
                print("응답 디코딩 실패")
                print(error.localizedDescription)
                dump(error)
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
            
            
            //completion(1)
        })
        task.resume()
    }
}


