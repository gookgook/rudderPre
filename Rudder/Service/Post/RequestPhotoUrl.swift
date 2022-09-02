//
//  RequestPhotoUrl.swift
//  Rudder
//
//  Created by Brian Bae on 06/09/2021.
//

import Foundation



struct RequestPhotoUrl {
    static func uploadInfo(postId: Int, contentType: String, fileName: String, completion: @escaping (String?) -> Void) -> Void{ // completion optional!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
        let url : URL = URL(string: "http://api.rudderuni.com/posts/image-upload-url/generate")!
        
        guard let token: String = UserDefaults.standard.string(forKey: "token"),
              token.isEmpty == false else {
            print("no token")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.allHTTPHeaderFields = ["Authorization" : "Bearer "+token]

        
        let urlGetRequest = UrlGetRequest(imageMetaData: [ImageMetaData(contentType: contentType, fileName: fileName)], postId: postId)
        
        
        guard let EncodedUploadData = try? JSONEncoder().encode(urlGetRequest) else { return }
      
        let task = URLSession.shared.uploadTask(with: request, from: EncodedUploadData, completionHandler: { (data, response, error) in
            if let error = error {
                print ("error: \(error)")
                return
            }
            guard let response = response as? HTTPURLResponse,
                (200...299).contains(response.statusCode) else {
                print ("server error sdfgsdfg")
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
                let TResponse: ResponseGetUrl = try decoder.decode(ResponseGetUrl.self, from: data)
                //let decodedResponse: Response = try decoder.decode(Response.self, from: data)
                DispatchQueue.main.async {
                    completion(TResponse.uploadUrls[0].url)
                }
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

extension RequestPhotoUrl {
    struct UrlGetRequest: Codable {
        let imageMetaData: [ImageMetaData]
        let postId: Int
    }
    
    struct GetUrlResponse: Codable {
        let url: String
    }
    
    struct ResponseGetUrl: Codable {
        let uploadUrls: [GetUrlResponse]
    }
}
