//
//  RequestMakePre.swift
//  Rudder
//
//  Created by 박민호 on 2022/07/12.
//

import Foundation

struct RequestMakePre {
    //login
    static func uploadInfo(categoryId: Int, postBody: String, isEmageExist: Bool, completion: @escaping (Int) -> Void) -> Void{
        let url = URL(string: Utils.springUrlKey+"/parties")!
        
        guard let token: String = UserDefaults.standard.string(forKey: "token"),
              token.isEmpty == false else {
            print("no token")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.allHTTPHeaderFields = [ "Authorization" : "Bearer "+token ]
        
        let postToAdd = PostToAdd(categoryId: categoryId, isImageExist: isEmageExist, postBody: postBody)
        
        guard let EncodedUploadData = try? JSONEncoder().encode(postToAdd) else {
            return
        }
      
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
            
            guard let data = data else {
                print("전달받은 데이터 없음")
                DispatchQueue.main.async {
                    completion(-1)  //error handle !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
                }
                return
            }
            
            let decoder:JSONDecoder = JSONDecoder()
            do {
                let decodedResponse: AddPostResponse = try decoder.decode(AddPostResponse.self, from: data)
                DispatchQueue.main.async {
                    completion(decodedResponse.postId)
                }
            } catch {
                print("응답 디코딩 실패 헀음 했음")
                print(error.localizedDescription)
                dump(error)
                DispatchQueue.main.async {
                    completion(-1)
                }
            }
            
        })
        task.resume()
    }
}

extension RequestMakePre {
    struct AddPostResponse: Codable {
        let postId: Int
    }
}
