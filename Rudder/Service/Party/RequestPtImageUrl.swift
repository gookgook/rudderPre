//
//  RequestPtImageUrl.swift
//  Rudder
//
//  Created by 박민호 on 2022/07/18.
//

import Foundation

struct RequestPtImageUrl { //Request Party-profile image upload url
    //login
    static func uploadInfo(partyId: Int,imageMetadata: ImageMetaData, completion: @escaping ([String]?) -> Void) -> Void{ // completion optional!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
        let url : URL = URL(string: "http://test.rudderuni.com/parties/image-upload-url/generate")!
     
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let urlGetRequest = UrlGetRequest(imageMetaData: imageMetadata, partyId: partyId)
        
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
                completion(nil)  //error handle
                return
            }
            
            let decoder:JSONDecoder = JSONDecoder()
            do {
                let TResponse: ResponseGetUrl = try decoder.decode(ResponseGetUrl.self, from: data)
                //let decodedResponse: Response = try decoder.decode(Response.self, from: data)
                DispatchQueue.main.async {
                    completion(TResponse.urls)
                }
            } catch {
                print("응답 디코딩 실패")
                print(error.localizedDescription)
                dump(error)
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        })
        task.resume()
    }
}

extension RequestPtImageUrl {
    struct UrlGetRequest: Codable {
        let imageMetaData: ImageMetaData
        let partyId: Int
    }

    struct ResponseGetUrl: Codable {
        let urls: [String]
    }
}
