//
//  RequestEmailVerify.swift
//  Rudder
//
//  Created by Brian Bae on 09/09/2021.
//

import Foundation

struct RequestEmailVerify {
    //login
    static func uploadInfo(schoolEmail: String, completion: @escaping (String) -> Void) -> Void{ //학교 이름을 넘겨줄 수도 있어서
        let url = URL(string: (Utils.springUrlKey + "/email/" + schoolEmail + "/validate"))!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
      
        let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
            if let error = error { print ("error: \(error)"); completion("-1"); return }
            guard let response = response as? HTTPURLResponse else { print ("server error"); completion("-1"); return }
            
            print("statuscode: ",String(response.statusCode))
            
            switch response.statusCode {
            case 200...299:
                let decoder:JSONDecoder = JSONDecoder()
                do {
                    guard let data = data else {
                        print("전달받은 데이터 없음")
                        completion("-1")
                        return
                    }
                    let decodedResponse: EmailVerifyResponse = try decoder.decode(EmailVerifyResponse.self, from: data)
                        completion(decodedResponse.schoolName)
                } catch {
                    print("응답 디코딩 실패 회원가입시 school name")
                    print(error.localizedDescription)
                    dump(error)
                    completion("-1")
                 }
            case 406:
                completion("2")
            case 409:
                completion("3")
            default :
                print("Unknown Error")
                completion("-1")
            }
            return
        })
        task.resume()
    }
}


extension RequestEmailVerify {
    struct EmailVerifyResponse : Codable {
        let schoolId: Int
        let schoolName: String
    }
}
