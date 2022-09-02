//
//  RequestBasic.swift
//  Rudder
//
//  Created by Brian Bae on 05/08/2021.
//

import Foundation

struct RequestBasic {
    //login
    static func uploadInfo(EncodedUploadData: Data, completion: @escaping (Int) -> Void) -> Void{ //1: success 2:인

   
        let url = URL(string: ("http://api.rudderuni.com" + "/auth"))!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
      
        let task = URLSession.shared.uploadTask(with: request, from: EncodedUploadData, completionHandler: { (data, response, error) in
            if let error = error {
                print ("error: \(error)")
                return
            }
            guard let response = response as? HTTPURLResponse else {
                print ("server error")
                return
            }
            
            guard let data = data, error == nil else {
                print("server error")
                return
            }
            
            let decoder:JSONDecoder = JSONDecoder()
            
            print("status"+String(response.statusCode))
            
            guard (200...299).contains(response.statusCode) else {
                do {
                let decodedResponse: ErrorHandle = try decoder.decode(ErrorHandle.self, from: data)
                    switch response.statusCode {
                    case 401 :
                        if decodedResponse.code == "EMAIL_NOT_VERIFIED" { completion(2) }
                        else if decodedResponse.code == "PASSWORD_WRONG" { completion(3) }
                    case 404 :
                        completion(4)
                    default :
                        print("Unknown Error")
                        completion(-1)
                    }
                }catch{
                    completion(-1)
                }
                return
            }
          
            do {
                let decodedResponse: LoginResponse = try decoder.decode(LoginResponse.self, from: data)
                UserDefaults.standard.set(decodedResponse.accessToken, forKey: "token")
                UserDefaults.standard.set(decodedResponse.userInfoId, forKey: "userInfoId")
                UserDefaults.standard.synchronize()
                completion(1)
               } catch let error as NSError {
                   print(error)
                   completion(-1)
               }
        })
        task.resume()
    }
    
    //idDuplicationCheck
    static func checkIdDuplication(EncodedUploadData: Data, completion: @escaping (Int) -> Void) -> Void{
        let url = URL(string: Utils.urlKey+"/signupin/checkduplication")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.uploadTask(with: request, from: EncodedUploadData, completionHandler: { (data, response, error) in
            if let error = error {
                print ("error: \(error)")
                return
            }
            guard let response = response as? HTTPURLResponse,
                (200...299).contains(response.statusCode) else {
                print ("server error")
                return
            }
            
            guard let data = data else {
                print("전달받은 데이터 없음")
                DispatchQueue.main.async {
                    completion(3)
                }
                return
            }
            
            
            if let JSONString = String(data: data, encoding: String.Encoding.utf8) { //지워야함
               print(JSONString)
            }
            
            let decoder:JSONDecoder = JSONDecoder()
            do {
                
                let decodedResponse: DuplicateResponse = try decoder.decode(DuplicateResponse.self, from: data)
                DispatchQueue.main.async {
                    if decodedResponse.results.isDuplicated == true {
                        completion(1)
                    }else{
                        completion(2)
                    }
                }
            } catch {
                print("응답 디코딩 실패")
                print(error.localizedDescription)
                dump(error)
                DispatchQueue.main.async {
                    completion(3)
                }
            }
        })
        task.resume()
    }
    
    
    //verifyemail
    static func verifyEmail(EncodedUploadData: Data, completion: @escaping (Int) -> Void) -> Void{
        let url = URL(string: Utils.urlKey+"/signupin/checkduplication")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.uploadTask(with: request, from: EncodedUploadData, completionHandler: { (data, response, error) in
            if let error = error {
                print ("error: \(error)")
                return
            }
            guard let response = response as? HTTPURLResponse,
                (200...299).contains(response.statusCode) else {
                print ("server error")
                
                return
            }
            
            
            guard let data = data else {
                print("전달받은 데이터 없음")
                DispatchQueue.main.async {
                    completion(3)
                }
                return
            }
            
            
            if let JSONString = String(data: data, encoding: String.Encoding.utf8) { //지워야함
               print(JSONString)
            }
            
            let decoder:JSONDecoder = JSONDecoder()
            do {
                /*let TResponse: [Comment] = try decoder.decode([Comment].self, from: data)
                let decodedResponse: ResponseComment = ResponseComment(comments: TResponse)*/
                
                let decodedResponse: DuplicateResponse = try decoder.decode(DuplicateResponse.self, from: data)
                DispatchQueue.main.async {
                    if decodedResponse.results.isDuplicated == true {
                        completion(1)
                    }else{
                        completion(2)
                    }
                }
            } catch {
                print("응답 디코딩 실패")
                print(error.localizedDescription)
                dump(error)
                DispatchQueue.main.async {
                    completion(3)
                }
            }
        })
        
        task.resume()
        
    }

}
extension RequestBasic {
   
    struct LoginResponse: Codable{
        let accessToken: String
        let userInfoId: Int
    }
    
}


