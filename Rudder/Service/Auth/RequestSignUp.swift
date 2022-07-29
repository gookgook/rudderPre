//
//  RequestSignUp.swift
//  Rudder
//
//  Created by Brian Bae on 13/09/2021.
//

import Foundation

struct RequestSignUp {
    //login
    static func uploadInfo(promotionMailAgreement: Bool, userEmail: String, userPassword: String, userNickname: String ,userProfileBody: String, completion: @escaping (Int?) -> Void) -> Void{
        let url = URL(string: Utils.springUrlKey+"/user-infos")!
    
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
      
        let signUpInfo = SignUpInfo(promotionMailAgreement: promotionMailAgreement, userEmail: userEmail, userPassword: userPassword, userNickname: userNickname, userProfileBody: userProfileBody)
        
        guard let EncodedUploadData = try? JSONEncoder().encode(signUpInfo) else {
            return
        }
        
        let task = URLSession.shared.uploadTask(with: request, from: EncodedUploadData, completionHandler: { (data, response, error) in
            if let error = error {
                print ("error: \(error)")
                completion(nil)
                return
            }
            guard let response = response as? HTTPURLResponse else {
                print ("server error")
                completion(nil)
                return
            }
            
            switch response.statusCode {
            case 201:
                let decoder:JSONDecoder = JSONDecoder()
                do {
                    guard let data = data else {
                        print("전달받은 데이터 없음")
                        completion(nil)
                        return
                    }
                    let decodedResponse: SignUpResponse = try decoder.decode(SignUpResponse.self, from: data)
                    completion(decodedResponse.userInfoId)
                } catch {
                    print("응답 디코딩 실패 회원가입시 닉네임이 받는부분")
                    print(error.localizedDescription)
                    dump(error)
                    completion(nil)
                }
            default :
                print("Unknown Error")
                completion(nil)
            }
               
            return
            
        })
        task.resume()
    }
}


extension RequestSignUp {
    struct SignUpInfo : Codable {
        let promotionMailAgreement: Bool
        let userEmail: String
        let userPassword: String
        let userNickname: String
        let userProfileBody: String
    }
    struct SignUpResponse : Codable {
        let userInfoId: Int
    }
}
